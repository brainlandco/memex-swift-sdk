
import Foundation
import ObjectMapper

extension Spaces {
  
  // MARK: Requesting
  
  typealias ResponseHandlerClosure = (_ response: Response)->()
  
  func HEAD(endpoint: String,
                   parameters: [String: Any]? = nil,
                   completion: ResponseHandlerClosure? = nil) {
    self.requestor.request(
      method: .HEAD,
      path: endpoint,
      queryStringParameters: parameters,
      bodyParameters: nil,
      completionHandler: { [weak self] content, code, headers, error in
        self?.processResponseContent(content: content, code: code, headers: headers,
                                     error: error, responseHandler: completion)
      })
  }
  
  func GET(_ endpoint: String,
                  parameters: [String: Any]? = nil,
                  completion: ResponseHandlerClosure? = nil) {
    self.requestor.request(
      method: .GET,
      path: endpoint,
      queryStringParameters: parameters,
      bodyParameters: nil,
      completionHandler: { [weak self] content, code, outHeaders, error in
        self?.processResponseContent(content: content, code: code, headers: outHeaders, error: error, responseHandler: completion)
      })
  }
  
  func POST(_ endpoint: String,
                   parameters: AnyObject? = nil,
                   headers: [String: String]? = nil,
                   completion: ResponseHandlerClosure? = nil) {
    self.requestor.request(
      method: .POST,
      path: endpoint,
      queryStringParameters: nil,
      bodyParameters: parameters,
      headers: headers,
      completionHandler: { [weak self] content, code, outHeaders, error in
        self?.processResponseContent(content: content, code: code, headers: outHeaders, error: error, responseHandler: completion)
      })
  }
  
  func PUT(_ endpoint: String,
                  parameters: AnyObject? = nil,
                  completion: ResponseHandlerClosure? = nil) {
    self.requestor.request(
      method: .PUT,
      path: endpoint,
      queryStringParameters: nil,
      bodyParameters: parameters,
      completionHandler: { [weak self] content, code, outHeaders, error in
        self?.processResponseContent(content: content, code: code, headers: outHeaders, error: error, responseHandler: completion)
      })
  }
  
  func DELETE(_ endpoint: String,
                     parameters: [String: Any]? = nil,
                     completion: ResponseHandlerClosure? = nil) {
    self.requestor.request(
      method: .DELETE,
      path: endpoint,
      queryStringParameters: parameters,
      bodyParameters: nil,
      completionHandler: { [weak self] content, code, outHeaders, error in
        self?.processResponseContent(content: content, code: code, headers: outHeaders,
                                     error: error, responseHandler: completion)
      })
  }
  
  func processResponseContent(content: AnyObject?,
                              code: Int?,
                              headers: [AnyHashable: Any]?,
                              error: Swift.Error?,
                              responseHandler: ResponseHandlerClosure? = nil) {
    let response = Response()
    response.content = content as AnyObject?
    if let error = error {
      response.error = error
    }
    response.httpErrorCode = code
    response.headers = headers
    responseHandler?(response)
  }
  
  // MARK: Helpers
  
  func dictionaryFromObject<T: JSONRepresentable>(object: T?) -> Any?? {
    guard let object = object else { return nil }
    return Mapper<T>().toJSON(object)
  }
  
  func dictionaryFromEntity<T: JSONRepresentable>(array: [T]?) -> Any?? {
    guard let array = array else { return nil }
    return Mapper<T>().toJSONArray(array)
  }
  
  func entityFromDictionary<T: JSONRepresentable>(dictionary: Any?) -> T? {
    guard let castedDictionary = dictionary as? [String: Any] else { return nil }
    return Mapper<T>().map(JSON: castedDictionary)
  }
  
  func entitiesFromArray<T: JSONRepresentable>(array: Any?) -> [T]? {
    guard let castedArray = array as? [[String: Any]] else { return nil }
    
    var entitites = [T]()
    for dictionary in castedArray {
      let entity: T? = self.entityFromDictionary(dictionary: dictionary)
      if let entity = entity {
        entitites.append(entity)
      }
    }
    return entitites
  }
  
  func parametersFromPagination(pagination: [String: Any]?) -> [String: Any] {
    var parameters = [String: Any]()
    if let pagination = pagination {
      parameters["pagination"] = pagination
    }
    return parameters
  }
  
  func paginationFromMetadata(metadata: [String: Any]?) -> [String: Any]? {
    let pagination = metadata?["pagination"] as? [String: Any]
    if pagination?.isEmpty == true {
      return nil
    } else {
      return pagination
    }
  }
  
  func nextPageParameters(metadata: [String: Any]?) -> [String: Any]? {
    return self.paginationFromMetadata(metadata: metadata)?["next_page_params"] as? [String: Any]
  }
  
}
