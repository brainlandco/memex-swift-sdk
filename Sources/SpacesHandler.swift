import Foundation
import ObjectMapper


public extension Spaces {
  
  
  /**
   New space creation.
   
   - parameter space: New space object
   - parameter process: Tells if/how you want to process this space.
   - parameter autodump: If true it will automatically link space with most related already existing space
   - parameter completion: Completion block
   - parameter spaceMUID: MUID of created space
   - parameter error: Error if something wrong happens
   
   */
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
  
  
  /**
   If you want create multiple spaces or sync your local model then this method is for you.
   
   - parameter items: Set of new or changed spaces
   - parameter completion: Completion block
   
   */
  public func pushSpaces(items: [Space],
                         completion: @escaping PushOutputs) {
    POST("spaces/multiple",
         parameters:["spaces": items.toJSON()]) { response in
          let oldModelVersion = response.contentDictionary?["old_model_version"] as? Int
          let modelVersion = response.contentDictionary?["model_version"] as? Int
          completion(oldModelVersion, modelVersion, response.error)
    }
  }
  
  /**
   Method for fetching all accessible spaces.
   
   - parameter lastModelVersion: Last user model version that was fetched (allows diff downlaods)
   - parameter offset: There can be only limited number of spaces in response so pagination offset can be sometimes needed.
   - parameter completion: Completion block.
   
   */
  public func pullSpaces(lastModelVersion: Int?,
                         offset: Int?,
                         completion: @escaping PullOutputs<Space>) {
    var parameters = [String: Any]()
    if let value = lastModelVersion {
      parameters["last_model_version"] = value
    }
    if let value = offset {
      parameters["offset"] = value
    }
    GET("spaces",
        parameters: parameters) { [weak self] response in
          let items: [Space]? = self?.entitiesFromArray(array: response.contentDictionary?["spaces"])
          let modelVersion = response.contentDictionary?["model_version"] as? Int
          let totalItems = response.contentDictionary?["total"] as? Int
          let hasMore = response.contentDictionary?["has_more"] as? Bool
          let nextOffset = response.contentDictionary?["next_offset"] as? Int
          completion(items, modelVersion, totalItems, hasMore, nextOffset, response.error)
    }
  }
  
  
  /**
   Logs space visits
   
   - parameter visits: Array of space visits. Can contain multiple spaces with same MUID.
   - parameter completion: Completion block that returns error if something wrong happens.
   
   */
  public func logSpaceVisits(visits: [SpaceVisit],
                             completion: @escaping VoidOutputs) {
    POST("spaces/log-visits",
         parameters: [
          "spaces": Mapper<SpaceVisit>().toJSONArray(visits)
    ]) { response in
      completion(response.error)
    }
  }
  
  /**
   Returns abstraction (caption) for set of spaces
   
   - parameter muids: Set of space MUIDs for that will be caption generated
   - parameter completion: Completion block
   - parameter caption: Automatically generated caption
   - parameter error: Error if something wrong happens
   
   */
  public func getSpacesAbstract(muids: [String],
                                completion: @escaping (_ caption: String?, _ error: Swift.Error?)->()) {
    POST("spaces/abstract",
         parameters: [
          "space_MUIDs": muids
    ]) { response in
      completion(response.contentDictionary?["caption"] as? String, response.error)
    }
  }
}



