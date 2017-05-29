
import Foundation
import ObjectMapper

public typealias PullSpacesOutputs = (
  _ items: [Space]?,
  _ modelVersion: Int?,
  _ totalItems: Int?,
  _ hasMore: Bool?,
  _ nextOffset: Int?,
  _ error: Swift.Error?)->()

public typealias PushOutputs = (
  _ oldModelVersion: Int?,
  _ modelVersion: Int?,
  _ error: Swift.Error?)->()


public enum ProcessingMode: String {
  case No = "no"
  case Async = "async"
  case Sync = "sync"
}

public extension Spaces {
  
  public func createSpace(space: Space,
                          process: ProcessingMode,
                          autodump: Bool,
                          completion: @escaping (_ spaceMUID: String?, _ error: Swift.Error?)->()) {
    var spaceJSON = space.toJSON()
    spaceJSON["representations"] = space.representations.flatMap { media in
      media.toJSON()
    }
    let parameters: [String: Any] = ["space": spaceJSON,
                                     "process": process.rawValue,
                                     "autodump": autodump]
    POST("spaces", parameters: parameters ) { response in
      let space = response.contentDictionary?["space"] as? [String: Any]
      completion(space?["muid"] as? String, response.error)
    }
  }
  
  public func pushSpaces(items: [Space],
                         completion: @escaping PushOutputs) {
    POST("spaces/batched",
         parameters:["data": items.toJSON()]) { response in
          let oldModelVersion = response.contentDictionary?["old_model_version"] as? Int
          let modelVersion = response.contentDictionary?["model_version"] as? Int
          completion(oldModelVersion, modelVersion, response.error)
    }
  }
  
  public func pullSpaces(lastModelVersion: Int?,
                         offset: Int?,
                         completion: @escaping PullSpacesOutputs) {
    var parameters = [String: Any]()
    if let value = lastModelVersion {
      parameters["last_model_version"] = value
    }
    if let value = offset {
      parameters["offset"] = value
    }
    GET("users/self/spaces",
        parameters: parameters) { [weak self] response in
          let items: [Space]? = self?.entitiesFromArray(array: response.contentDictionary?["spaces"])
          let modelVersion = response.contentDictionary?["model_version"] as? Int
          let totalItems = response.contentDictionary?["total"] as? Int
          let hasMore = response.contentDictionary?["has_more"] as? Bool
          let nextOffset = response.contentDictionary?["next_offset"] as? Int
          completion(items, modelVersion, totalItems, hasMore, nextOffset, response.error)
    }
  }
  
  public func logSpaceVisits(visits: [SpaceVisit],
                             completion: @escaping VoidOutputs) {
    POST("spaces/log-visits",
         parameters: [
          "spaces": Mapper<SpaceVisit>().toJSONArray(visits)
    ]) { response in
      completion(response.error)
    }
  }
}



