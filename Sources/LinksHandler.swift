import Foundation
import ObjectMapper


public extension Spaces {
  /**
   New media creation. This method allows you to sync multiple media. If there is some data that needs to be uploaded put it to dataUploadURL and call markMediaAsUploaded.
   
   - parameter media: Set of new or changed links
   - parameter completion: Completion block
   - parameter removeToken: Entities can have assigned remove token and it can be used to easily remove them before they are replaced by another ones
   - parameter media: Media object with valid dataUploadURL
   - parameter error: Error if something wrong happens
   
   */
  public func createLinks(links: [Link],
                          removeToken: String? = nil,
                          completion: @escaping PushOutputs<Link>) {
    
    var headers = [String: String]()
    if let value = removeToken {
      headers[HTTPHeader.removeTokenHeader] = value
    }
    
    let array = links.map { item -> AnyObject in
      var json = item.toJSON()
      json.removeValue(forKey: "owner_id")
      return json as AnyObject
    }
    
    POST("teams/personal/links", parameters:array as AnyObject, headers: headers) { [weak self] response in
      var oldModelVersion: Int?
      if let value = response.headers?[HTTPHeader.previousModelVersionHeader] {
        oldModelVersion = Int(value as! String)
      }
      var modelVersion: Int?
      if let value = response.headers?[HTTPHeader.modelVersionHeader] {
        modelVersion = Int(value as! String)
      }
      let links: [Link]? = self?.entitiesFromArray(array: response.content)
      completion(links, oldModelVersion, modelVersion, response.error)
    }
  }
  
  
  /**
   Method for getting space links
   
   - parameter muid: MUID of space or 'origin'
   - parameter completion: Completion block.
   - parameter links: Fetched space links.
   - parameter error: Error message if something wrong happens.
   
   */
  public func getSpaceLinks(muid: String,
                            completion: @escaping (_ space: [Link]?, _ error: Swift.Error?)->()) {
    GET("teams/personal/spaces/\(muid)/links") { [weak self] response in
      let links: [Link]? = self?.entitiesFromArray(array: response.content)
      completion(links, response.error)
    }
  }
  
  
  /**
   Method for fetching all accessible links.
   
   - parameter lastModelVersion: Last user model version that was fetched (allows diff downloads)
   - parameter limit: There can be only limited number of items in response so pagination offset can be sometimes needed.
   - parameter offset: There can be only limited number of items in response so pagination offset can be sometimes needed.
   - parameter completion: Completion block.
   
   */
  public func pullLinks(lastModelVersion: Int?,
                        offset: Int?,
                        limit: Int? = nil,
                        completion: @escaping PullOutputs<Link>) {
    var parameters = [String: Any]()
    if let value = lastModelVersion {
      parameters["last_model_version"] = value
    }
    if let value = offset {
      parameters["offset"] = value
    }
    if let value = limit {
      parameters["limit"] = value
    }
    GET("teams/personal/links",
        parameters: parameters) { [weak self] response in
          let items: [Link]? = self?.entitiesFromArray(array: response.content)
          var modelVersion: Int?
          if let value = response.headers?[HTTPHeader.modelVersionHeader] {
            modelVersion = Int(value as! String)
          }
          var totalItems: Int?
          if let value = response.headers?[HTTPHeader.paginationTotalHeader] {
            totalItems = Int(value as! String)
          }
          var nextOffset: Int?
          if let value = response.headers?[HTTPHeader.paginationNextOffsetHeader] {
            nextOffset = Int(value as! String)
          }
          var hasMore: Bool? = false
          if let value = response.headers?[HTTPHeader.paginationHasMoreHeader] {
            hasMore = (value as! String) == "true"
          }
          completion(items, modelVersion, totalItems, hasMore, nextOffset, response.error)
    }
  }
  
}



