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

public class SUResponse {
  
  public var content: AnyObject?
  public var data: AnyObject?
  public var metadata: [String: AnyObject]?
  public var error: ErrorType?
  
  public init() {
  }
  
}

public class SUOperation<P: OPOperationParameters, R: OPOperationResults>: OPOperation<P, R, OPVoidOperationIdentifiersSet> {
  
  
  
  // MARK: Properties
  
  public var sushiModule: SUModule {
    return self.operationModule as! SUModule
  }
  
  // MARK: Lifecycle
  
  public override init(module: OPModuleProtocol!, file: StaticString = #file) {
    super.init(module: module ?? SUModule.sharedModule!, file: file)
  }
  
  // MARK: Requesting
  
  public typealias ResponseHandlerClosure = (response: SUResponse)->()
  
  public func HEAD(endpoint: String,
                   parameters: [String: AnyObject]? = nil,
                   completion: ResponseHandlerClosure? = nil) {
    self.sushiModule.requestInvoker.request(
      method: .HEAD,
      path: endpoint,
      queryStringParameters: parameters,
      bodyParameters: nil,
      authorize: true,
      authorizationHeaderValue: nil,
      completionHandler: { [weak self] content, code, error in
        self?.processResponseContent(content, code: code, error: error, responseHandler: completion)
      })
  }
  
  public func GET(endpoint: String,
                  parameters: [String: AnyObject]? = nil,
                  completion: ResponseHandlerClosure? = nil) {
    self.sushiModule.requestInvoker.request(
      method: .GET,
      path: endpoint,
      queryStringParameters: parameters,
      bodyParameters: nil,
      authorize: true,
      authorizationHeaderValue: nil,
      completionHandler: { [weak self] content, code, error in
        self?.processResponseContent(content, code: code, error: error, responseHandler: completion)
      })
  }
  
  public func POST(endpoint: String,
                   parameters: [String: AnyObject]? = nil,
                   completion: ResponseHandlerClosure? = nil) {
    self.sushiModule.requestInvoker.request(
      method: .POST,
      path: endpoint,
      queryStringParameters: nil,
      bodyParameters: parameters,
      authorize: true,
      authorizationHeaderValue: nil,
      completionHandler: { [weak self] content, code, error in
        self?.processResponseContent(content, code: code, error: error, responseHandler: completion)
      })
  }
  
  public func PUT(endpoint: String,
                  parameters: [String: AnyObject]? = nil,
                  completion: ResponseHandlerClosure? = nil) {
    self.sushiModule.requestInvoker.request(
      method: .PUT,
      path: endpoint,
      queryStringParameters: nil,
      bodyParameters: parameters,
      authorize: true,
      authorizationHeaderValue: nil,
      completionHandler: { [weak self] content, code, error in
        self?.processResponseContent(content, code: code, error: error, responseHandler: completion)
      })
  }
  
  public func DELETE(endpoint: String,
                     parameters: [String: AnyObject]? = nil,
                     completion: ResponseHandlerClosure? = nil) {
    self.sushiModule.requestInvoker.request(
      method: .DELETE,
      path: endpoint,
      queryStringParameters: parameters,
      bodyParameters: nil,
      authorize: true,
      authorizationHeaderValue: nil,
      completionHandler: { [weak self] content, code, error in
        self?.processResponseContent(content, code: code, error: error, responseHandler: completion)
      })
  }
  
  func processResponseContent(content: [String: AnyObject]?,
                              code: Int?,
                              error: ErrorType?,
                              responseHandler: ResponseHandlerClosure? = nil) {
    let response = SUResponse()
    response.content = content
    if let error = error {
      response.error = error
      self.failWithErrors([error])
    } else {
      response.data = content?["data"]
      response.metadata = content?["meta"] as? [String: AnyObject]
      responseHandler?(response: response)
      self.succeed()
    }
  }
  
  // MARK: Helpers
  
  public func dictionaryFromObject<T: SUEntity>(object: T?) -> AnyObject?? {
    guard let object = object else { return nil }
    return SUMapper<T>().toJSON(object)
  }
  
  public func dictionaryFromEntity<T: SUEntity>(array: [T]?) -> AnyObject?? {
    guard let array = array else { return nil }
    return SUMapper<T>().toJSONArray(array)
  }
  
  public func entityFromDictionary<T: SUEntity>(dictionary: AnyObject?) -> T? {
    let castedDictionary = dictionary as? [String: AnyObject]
    return SUMapper<T>().map(castedDictionary)
  }
  
  public func entitiesFromArray<T: SUEntity>(array: AnyObject?) -> [T]? {
    let castedArray = array as? [[String: AnyObject]]
    if let castedArray = castedArray {
      var entitites = [T]()
      for dictionary in castedArray {
        let entity: T? = entityFromDictionary(dictionary)
        if let entity = entity {
          entitites.append(entity)
        }
      }
      return entitites
    } else {
      return nil
    }
  }
  
  public func parametersFromPagination(pagination: [String: AnyObject]?) -> [String: AnyObject] {
    var parameters = [String: AnyObject]()
    if let pagination = pagination {
      parameters["pagination"] = pagination
    }
    return parameters
  }
  
  public func paginationFromMetadata(metadata: [String: AnyObject]?) -> [String: AnyObject]? {
    let pagination = metadata?["pagination"] as? [String: AnyObject]
    if pagination?.isEmpty == true {
      return nil
    } else {
      return pagination
    }
  }
  
  public func nextPageParameters(metadata: [String: AnyObject]?) -> [String: AnyObject]? {
    return self.paginationFromMetadata(metadata)?["next_page_params"] as? [String: AnyObject]
  }
  
}
