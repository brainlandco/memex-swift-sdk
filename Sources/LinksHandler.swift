import Foundation
import ObjectMapper


public extension Spaces {
  
  /**
   Method for fetching all accessible links.
   
   - parameter lastModelVersion: Last user model version that was fetched (allows diff downlaods)
   - parameter offset: There can be only limited number of items in response so pagination offset can be sometimes needed.
   - parameter completion: Completion block.
   
   */
  public func pullLinks(lastModelVersion: Int?,
                        offset: Int?,
                        completion: @escaping PullOutputs<Link>) {
    var parameters = [String: Any]()
    if let value = lastModelVersion {
      parameters["last_model_version"] = value
    }
    if let value = offset {
      parameters["offset"] = value
    }
    GET("links",
        parameters: parameters) { [weak self] response in
          let items: [Link]? = self?.entitiesFromArray(array: response.contentDictionary?["links"])
          let modelVersion = response.contentDictionary?["model_version"] as? Int
          let totalItems = response.contentDictionary?["total"] as? Int
          let hasMore = response.contentDictionary?["has_more"] as? Bool
          let nextOffset = response.contentDictionary?["next_offset"] as? Int
          completion(items, modelVersion, totalItems, hasMore, nextOffset, response.error)
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
    GET("spaces/\(muid)/links") { [weak self] response in
      let links: [Link]? = self?.entitiesFromArray(array: response.contentDictionary?["links"])
      completion(links, response.error)
    }
  }
  
  /**
   This method allows you to sync multiple links
   
   - parameter items: Set of new or changed links
   - parameter completion: Completion block
   
   */
  public func pushLinks(items: [Link],
                        completion: @escaping PushOutputs) {
    POST("links/multiple",
         parameters:["links": items.toJSON()]) { response in
          let oldModelVersion = response.contentDictionary?["old_model_version"] as? Int
          let modelVersion = response.contentDictionary?["model_version"] as? Int
          completion(oldModelVersion, modelVersion, response.error)
    }
  }
  
}



