
import Foundation
import ObjectMapper

class RequestInvoker {
  
  // MARK: Lifecycle
  
  weak var spaces: Spaces?
  var session: URLSession
  
  // MARK: Lifecycle
  
  init(spaces: Spaces) {
    self.spaces = spaces
    self.session = URLSession(configuration: URLSessionConfiguration.default)
  }
  
  // MARK: General
  
  func request(
    method: HTTPMethod,
    path: String,
    queryStringParameters: [String: Any]? = nil,
    bodyParameters: [String: Any]? = nil,
    allowDeauthorization: Bool? = nil,
    completionHandler: @escaping RequestCompletion) {
    do {
      let request = try self.buildRequest(
        method: method,
        path: path,
        queryStringParameters: queryStringParameters,
        bodyParameters: bodyParameters,
        userToken: self.spaces!.auth.userToken)
      self.invokeRequest(request: request,
                         allowDeauthorization: allowDeauthorization ?? self.spaces?.configuration.allowDeauthorization ?? false,
                         completionHandler: completionHandler)
    } catch {
      completionHandler(nil, nil, MemexError.JSONParsingError)
    }
  }
  
  private func buildRequest(
    method: HTTPMethod,
    path: String,
    queryStringParameters: [String: Any]?,
    bodyParameters: [String: Any]?,
    userToken: String?) throws -> URLRequest {
    let base = self.spaces!.configuration.serverURL.appendingPathComponent(path)
    var path = "\(base.absoluteString)"
    if let query = queryStringParameters, !query.isEmpty {
      if let queryString = self.spaces!.queryStringTransformer.queryStringFromParameters(parameters: queryStringParameters,
                                                                                         error: nil) {
        path = "\(path)?\(queryString)"
      }
    }
    let url = URL(string: path)!
    
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    if let userToken = userToken {
      request.setValue(userToken, forHTTPHeaderField: HTTPHeader.userToken)
    }
    request.setValue(self.spaces!.configuration.appToken, forHTTPHeaderField: HTTPHeader.appToken)
    if let body = bodyParameters {
      request.setValue(MIMETypes.JSON, forHTTPHeaderField: HTTPHeader.contentType)
      let data = try JSONSerialization.data(withJSONObject: body, options: [])
      request.httpBody = data
    }
    return request
  }
  
  private func invokeRequest(request: URLRequest,
                             allowDeauthorization: Bool,
                             completionHandler: @escaping RequestCompletion) {
    var task: URLSessionTask!
    task = self.session.dataTask(with: request) { (data, response, error) -> Void in
      if error != nil {
        self.logRequest(request: task.originalRequest ?? request,
                        response: response,
                        resposneData: data)
        completionHandler(nil, nil, error)
      } else {
        self.processResponseWithRequest(request: request,
                                        response: response!,
                                        data: data!,
                                        allowDeauthorization: allowDeauthorization,
                                        completionHandler: completionHandler)
      }
    }
    task.resume()
  }
  
  private func processResponseWithRequest(
    request: URLRequest,
    response: URLResponse,
    data: Data,
    allowDeauthorization: Bool,
    completionHandler: RequestCompletion) {
    let httpResponse = response as! HTTPURLResponse
    let code = httpResponse.statusCode
    
    var printLog = false
    switch code {
    case 200..<300:
      printLog = printLog || self.spaces!.configuration.logAllRequests
      if data.count == 0 {
        completionHandler(nil, code, nil)
      } else {
        var content: [String: Any]?
        do {
          content = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
          completionHandler(nil, code, MemexError.JSONParsingError)
          return
        }
        
        completionHandler(content, code, nil)
      }
    default:
      printLog = true
      self.processResponseErrorWithCode(code: code,
                                        data: data,
                                        allowDeauthorization: allowDeauthorization,
                                        request: request,
                                        completionHandler: completionHandler)
    }
    if printLog {
      self.logRequest(request: request, response: response, resposneData: data)
    }
  }
  
  private func processResponseErrorWithCode(
    code: Int,
    data: Data?,
    allowDeauthorization: Bool,
    request: URLRequest,
    completionHandler: RequestCompletion) {
    
    let errorPayload = self.errorPayloadFromData(data: data)
    
    switch code {
    case 400..<500:
      var notAuthorized = false
      if let errorPayload = errorPayload, let errorCode = errorPayload.code {
        if errorCode == 401 || errorCode == 402 || errorCode == 403 {
          notAuthorized = true
        }
      }
      if code == 401 || code == 402 || code == 403 {
        notAuthorized = true
      }
      if notAuthorized {
        if allowDeauthorization {
          let requestedToken = request.allHTTPHeaderFields?[HTTPHeader.userToken]
          let currentToken = self.spaces!.auth.userToken
          if requestedToken == currentToken {
            self.spaces!.auth.deauthorize(completionHandler: { (error) in
              if error != nil {
                NSLog("Session invalidation failed")
              }
            })
          }
        }
        completionHandler(nil, code, MemexError.notAuthorized)
      } else {
        if code == 404 {
          completionHandler(nil, code, MemexError.endpointNotFound)
        } else {
          completionHandler(nil, code, MemexError.genericClientError)
        }
      }
    default:
      if code == 503 {
        self.spaces?.healthChecker.observedEnabledMaintanance()
        completionHandler(nil, code, MemexError.serverMaintanance)
      } else {
        completionHandler(nil, code, MemexError.genericServerError)
      }
    }
  }
  
  private func errorPayloadFromData(data: Data?) -> ErrorPayload? {
    do {
      var errorMessage: ErrorPayload?
      if let data = data {
        let json: [String: Any]? =
          try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        if let json = json, let errorDictionary = json["error"] {
          errorMessage = Mapper<ErrorPayload>().map(JSONObject: errorDictionary)
        }
      }
      return errorMessage
    } catch {
      return nil
    }
  }
  
  func logRequest(request: URLRequest, response: URLResponse?, resposneData: Data?) {
    var mutableRequest = request
    if mutableRequest.allHTTPHeaderFields?[HTTPHeader.userToken] != nil {
      mutableRequest.allHTTPHeaderFields?[HTTPHeader.userToken] = "<USER TOKEN>"
    }
    if mutableRequest.allHTTPHeaderFields?[HTTPHeader.appToken] != nil {
      mutableRequest.allHTTPHeaderFields?[HTTPHeader.appToken]  = "<APP TOKEN>"
    }
    if let httpResponse = response as? HTTPURLResponse, let data = resposneData {
      let code = httpResponse.statusCode
      var contentString = String(data: data, encoding: String.Encoding.utf8)
      if contentString == nil {
        contentString = "nil"
      }
      NSLog("\n\nREQUEST:\n\n\(mutableRequest.toCURL())\nRESPONSE:\n\nResponse Code: \(code)\nResponse Body:\n\(contentString!)\n\n-------------")
    } else {
      NSLog("\n\nREQUEST:\n\n\(mutableRequest.toCURL())")
    }
  }
}
