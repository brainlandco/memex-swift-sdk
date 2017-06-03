import Foundation
import ObjectMapper

public typealias PullLinksOutputs = (
  _ items: [Link]?,
  _ modelVersion: Int?,
  _ totalItems: Int?,
  _ hasMore: Bool?,
  _ nextOffset: Int?,
  _ error: Swift.Error?)->()

public extension Spaces {
  
  public func pullLinks(lastModelVersion: Int?,
                        offset: Int?,
                        completion: @escaping PullLinksOutputs) {
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



