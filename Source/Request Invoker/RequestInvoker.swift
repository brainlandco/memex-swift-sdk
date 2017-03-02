/**
 *
 * Copyright (c) 2015, Adam Zdara.
 * Created by: Adam Zdara on 16.12.2015
 *
 * All rights reserved. This source code can be used only for purposes specified
 * by the given license contract signed by the rightful deputy of Adam Zdara.
 * This source code can be used only by the owner of the license.
 *
 * Any disputes arising in respect of this agreement (license) shall be brought
 * before the Municipal Court of Prague.
 *
 */

import Foundation

public class SURequestInvoker {
  
  // MARK: Lifecycle
  
  weak var module: SUModule?
  var session: NSURLSession
  
  // MARK: Lifecycle
  
  init(module: SUModule) {
    self.module = module
    self.session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
  }
  
  // MARK: General
  
  public typealias RequestCompletion = (content: [String: AnyObject]?, code: Int?, error: ErrorType?)->()
  
  public func request(
    method method: SUHTTPMethod,
           path: String,
           queryStringParameters: [String: AnyObject]? = nil,
           bodyParameters: [String: AnyObject]? = nil,
           authorize: Bool = true,
           authorizationHeaderValue: String? = nil,
           completionHandler: RequestCompletion) {
    do {
      let request = try self.buildRequest(
        method: method,
        path: path,
        queryStringParameters: queryStringParameters,
        bodyParameters: bodyParameters,
        authorizationHeaderValue: authorizationHeaderValue)
      if authorize {
        self.module!.authorizationController.authorizeRequest(request) { error in
          if error == nil {
            self.invokeRequest(request, allowDeauthorization: true, completionHandler: completionHandler)
          } else {
            completionHandler(content: nil, code: nil, error: error)
          }
        }
      } else {
        self.invokeRequest(request, allowDeauthorization: true, completionHandler: completionHandler)
      }
    } catch {
      completionHandler(content: nil, code: nil, error: SUError.JSONParsingError)
    }
  }
  
  private func buildRequest(
    method method: SUHTTPMethod,
           path: String,
           queryStringParameters: [String: AnyObject]?,
           bodyParameters: [String: AnyObject]?,
           authorizationHeaderValue: String?) throws -> NSMutableURLRequest {
    let base = self.module!.configuration.serverURL.URLByAppendingPathComponent(path)
    var path = "\(base!.absoluteString!)"
    if let query = queryStringParameters where !query.isEmpty {
      if let queryString = self.module!.defaultQueryStringTransformer.queryStringFromParameters(queryStringParameters,
                                                                                                error: nil) {
        path = "\(path)?\(queryString)"
      }
    }
    let url = NSURL(string: path)!
    
    let request = NSMutableURLRequest(URL: url)
    request.HTTPMethod = method.rawValue
    if let userAgent = self.module!.configuration.userAgent {
      request.setValue(userAgent, forHTTPHeaderField: SUStandardHTTPHeader.UserAgent)
    }
    if let authorizationHeader = authorizationHeaderValue {
      request.setValue(authorizationHeader, forHTTPHeaderField: SUStandardHTTPHeader.Authorization)
    }
    if let body = bodyParameters {
      request.setValue(ATMIMETypes.JSON, forHTTPHeaderField: SUStandardHTTPHeader.ContentType)
      let data = try NSJSONSerialization.dataWithJSONObject(body, options: NSJSONWritingOptions())
      request.HTTPBody = data
    }
    return request
  }
  
  private func invokeRequest(request: NSMutableURLRequest, allowDeauthorization: Bool, completionHandler: RequestCompletion) {
    var task: NSURLSessionTask!
    task = self.session.dataTaskWithRequest(request) { (data, response, error) -> Void in
      if error != nil {
        self.logRequest(task.originalRequest ?? request, response: response, resposneData: data)
        completionHandler(content: nil, code: nil, error: error)
      } else {
        self.processResponseWithRequest(request, response: response!, data: data!,
                                        allowDeauthorization: allowDeauthorization, completionHandler: completionHandler)
      }
    }
    task.resume()
  }
  
  private func processResponseWithRequest(
    request: NSURLRequest,
    response: NSURLResponse,
    data: NSData,
    allowDeauthorization: Bool,
    completionHandler: RequestCompletion) {
    let httpResponse = response as! NSHTTPURLResponse
    let code = httpResponse.statusCode
    
    var printLog = false
    switch code {
    case 200..<300:
      printLog = printLog || self.module!.configuration.logAllRequests
      if data.length == 0 {
        completionHandler(content: nil, code: code, error: nil)
      } else {
        var content: [String: AnyObject]?
        do {
          content = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? [String: AnyObject]
        } catch {
          completionHandler(content: nil, code: code, error: SUError.JSONParsingError)
          return
        }
        completionHandler(content: content, code: code, error: nil)
      }
    default:
      self.processResponseErrorWithCode(code,
                                        data: data,
                                        allowDeauthorization: allowDeauthorization,
                                        completionHandler: completionHandler)
    }
    if printLog {
      self.logRequest(request, response: response, resposneData: data)
    }
  }
  
  private func processResponseErrorWithCode(
    code: Int,
    data: NSData?,
    allowDeauthorization: Bool,
    completionHandler: RequestCompletion) {
    
    let errorPayload = self.errorPayloadFromData(data)
    
    switch code {
    case 400..<500:
      var notAuthorized = false
      if let errorPayload = errorPayload, let errorCode = errorPayload.code {
        if errorCode == 401 || errorCode == 402 || errorCode == 403 || errorCode == 404 {
          notAuthorized = true
        }
      }
      if code == 401 || code == 402 || code == 403 {
        notAuthorized = true
      }
      if notAuthorized {
        if allowDeauthorization {
          ALLog("DEAUTHORIZE due to unauthorized request")
          self.module!.authorizationController.deauthorize()
        }
        completionHandler(content: nil, code: code, error: SUError.NotAuthorized)
      } else {
        if code == 404 {
          completionHandler(content: nil, code: code, error: SUError.EndpointNotFound)
        } else {
          completionHandler(content: nil, code: code, error: SUError.GenericClientError)
        }
      }
    default:
      if code == 503 {
        self.module?.healthChecker.observedEnabledMaintanance()
        completionHandler(content: nil, code: code, error: SUError.ServerMaintanance)
      } else {
        completionHandler(content: nil, code: code, error: SUError.GenericServerError)
      }
    }
  }
  
  private func errorPayloadFromData(data: NSData?) -> SUErrorPayload? {
    do {
      var errorMessage: SUErrorPayload?
      if let data = data {
        let json: [String: AnyObject]? =
          try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? [String: AnyObject]
        if let json = json,
          let errorDictionary = json["error"] {
          errorMessage = SUMapper<SUErrorPayload>().map(errorDictionary)
        }
      }
      return errorMessage
    } catch {
      return nil
    }
  }
  
  func logRequest(request: NSURLRequest, response: NSURLResponse?, resposneData: NSData?) {
    
    if let httpResponse = response as? NSHTTPURLResponse, let data = resposneData {
      let code = httpResponse.statusCode
      let contentString = NSString(data: data, encoding: NSUTF8StringEncoding)
      ALLog("\n\nREQUEST:\n\n\(request.toCURL())\nRESPONSE:\n\nResponse Code: \(code)\nResponse Body:\n\(contentString)\n\n-------------")
    } else {
      ALLog("\n\nREQUEST:\n\n\(request.toCURL())")
    }
  }
}
