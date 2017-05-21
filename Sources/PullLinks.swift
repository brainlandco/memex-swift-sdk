
import Foundation

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
    GET("users/self/links",
        parameters: parameters) { [weak self] response in
          let items: [Link]? = self?.entitiesFromArray(array: response.data)
          let modelVersion = response.metadata?["model_version"] as? Int
          let totalItems = response.metadata?["total"] as? Int
          let hasMore = response.metadata?["has_more"] as? Bool
          let nextOffset = response.metadata?["next_offset"] as? Int
          completion(items, modelVersion, totalItems, hasMore, nextOffset, response.error)
    }
  }

}



