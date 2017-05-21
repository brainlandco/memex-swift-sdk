
import Foundation
import ObjectMapper

public extension Service {
  
  // MARK: Requesting
  
  public typealias ResponseHandlerClosure = (_ response: Response)->()
  
  public func HEAD(endpoint: String,
                   parameters: [String: Any]? = nil,
                   completion: ResponseHandlerClosure? = nil) {
    self.requestor.request(
      method: .HEAD,
      path: endpoint,
      queryStringParameters: parameters,
      bodyParameters: nil,
      completionHandler: { [weak self] content, code, error in
        self?.processResponseContent(content: content, code: code, error: error, responseHandler: completion)
      })
  }
  
  public func GET(_ endpoint: String,
                  parameters: [String: Any]? = nil,
                  completion: ResponseHandlerClosure? = nil) {
    self.requestor.request(
      method: .GET,
      path: endpoint,
      queryStringParameters: parameters,
      bodyParameters: nil,
      completionHandler: { [weak self] content, code, error in
        self?.processResponseContent(content: content, code: code, error: error, responseHandler: completion)
      })
  }
  
  public func POST(_ endpoint: String,
                   parameters: [String: Any]? = nil,
                   completion: ResponseHandlerClosure? = nil) {
    self.requestor.request(
      method: .POST,
      path: endpoint,
      queryStringParameters: nil,
      bodyParameters: parameters,
      completionHandler: { [weak self] content, code, error in
        self?.processResponseContent(content: content, code: code, error: error, responseHandler: completion)
      })
  }
  
  public func PUT(_ endpoint: String,
                  parameters: [String: Any]? = nil,
                  completion: ResponseHandlerClosure? = nil) {
    self.requestor.request(
      method: .PUT,
      path: endpoint,
      queryStringParameters: nil,
      bodyParameters: parameters,
      completionHandler: { [weak self] content, code, error in
        self?.processResponseContent(content: content, code: code, error: error, responseHandler: completion)
      })
  }
  
  public func DELETE(_ endpoint: String,
                     parameters: [String: Any]? = nil,
                     completion: ResponseHandlerClosure? = nil) {
    self.requestor.request(
      method: .DELETE,
      path: endpoint,
      queryStringParameters: parameters,
      bodyParameters: nil,
      completionHandler: { [weak self] content, code, error in
        self?.processResponseContent(content: content, code: code, error: error, responseHandler: completion)
      })
  }
  
  func processResponseContent(content: [String: Any]?,
                              code: Int?,
                              error: Swift.Error?,
                              responseHandler: ResponseHandlerClosure? = nil) {
    let response = Response()
    response.content = content as AnyObject?
    if let error = error {
      response.error = error
    } else {
      response.data = content?["data"]
      response.metadata = content?["meta"] as? [String: Any]
    }
    responseHandler?(response)
  }
  
  // MARK: Helpers
  
  public func dictionaryFromObject<T: JSONRepresentable>(object: T?) -> Any?? {
    guard let object = object else { return nil }
    return Mapper<T>().toJSON(object)
  }
  
  public func dictionaryFromEntity<T: JSONRepresentable>(array: [T]?) -> Any?? {
    guard let array = array else { return nil }
    return Mapper<T>().toJSONArray(array)
  }
  
  public func entityFromDictionary<T: JSONRepresentable>(dictionary: Any?) -> T? {
    guard let castedDictionary = dictionary as? [String: Any] else { return nil }
    return Mapper<T>().map(JSON: castedDictionary)
  }
  
  public func entitiesFromArray<T: JSONRepresentable>(array: Any?) -> [T]? {
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
  
  public func parametersFromPagination(pagination: [String: Any]?) -> [String: Any] {
    var parameters = [String: Any]()
    if let pagination = pagination {
      parameters["pagination"] = pagination
    }
    return parameters
  }
  
  public func paginationFromMetadata(metadata: [String: Any]?) -> [String: Any]? {
    let pagination = metadata?["pagination"] as? [String: Any]
    if pagination?.isEmpty == true {
      return nil
    } else {
      return pagination
    }
  }
  
  public func nextPageParameters(metadata: [String: Any]?) -> [String: Any]? {
    return self.paginationFromMetadata(metadata: metadata)?["next_page_params"] as? [String: Any]
  }
  
}
