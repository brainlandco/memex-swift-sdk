import Foundation
import ObjectMapper

public extension Spaces {
  
  /**
   If you want create multiple spaces or sync your local model then this method is for you.
   
   - parameter items: Set of new or changed spaces
   - parameter process: Tells if/how you want to process this space.
   - parameter autodump: If true it will automatically link space with most related already existing space
   - parameter removeToken: Entities can have assigned remove token and it can be used to easily remove them before they are replaced by another ones
   - parameter completion: Completion block
   - parameter spaceMUID: MUID of created space
   - parameter error: Error if something wrong happens
   
   */
  public func createSpaces(spaces: [Space],
                           includeRepresentations: Bool,
                          process: ProcessingMode,
                          autodump: Bool,
                          removeToken: String?,
                          completion: @escaping PushOutputs<Space>) {
    
    var headers = [String: String]()
    headers[HTTPHeader.processingModeHeader] = process.rawValue
    if let value = removeToken {
      headers[HTTPHeader.removeTokenHeader] = value
    }
    headers[HTTPHeader.autodumpModeHeader] = autodump ? "true" : "false"
    
    let array = spaces.map { item -> AnyObject in
      var spaceJSON = item.toJSON()
      if includeRepresentations {
        spaceJSON["representations"] = item.representations.flatMap { media in
          media.toJSON()
        }
      }
      return spaceJSON as AnyObject
    }
    
    POST("teams/personal/spaces", parameters: array as AnyObject, headers: headers ) { [weak self] response in
      var oldModelVersion: Int?
      if let value = response.headers?[HTTPHeader.previousModelVersionHeader] {
        oldModelVersion = Int(value as! String)
      }
      var modelVersion: Int?
      if let value = response.headers?[HTTPHeader.modelVersionHeader] {
        modelVersion = Int(value as! String)
      }
      let spaces: [Space]? = self?.entitiesFromArray(array: response.content)
      completion(spaces, oldModelVersion, modelVersion, response.error)
    }
  }
  
  /**
   Method for getting specific space
   
   - parameter muid: MUID of space or 'origin'
   - parameter completion: Completion block.
   - parameter space: Fetched space.
   - parameter error: Error message if something wrong happens.
   
   */
  public func getSpace(muid: String,
                       completion: @escaping (_ space: Space?, _ error: Swift.Error?)->()) {
    GET("teams/personal/spaces/\(muid)") { [weak self] response in
      completion(self?.entityFromDictionary(dictionary: response.contentDictionary),
                 response.error)
    }
  }
  
  /**
   Log space visits
   
   - parameter visits: Array of space visits. Can contain multiple spaces with same MUID.
   - parameter completion: Completion block that returns error if something wrong happens.
   
   */
  public func logSpaceVisits(visits: [SpaceVisit],
                             completion: @escaping VoidOutputs) {
    POST("teams/personal/spaces/log-visits",
         parameters: Mapper<SpaceVisit>().toJSONArray(visits) as AnyObject
    ) { response in
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
    POST("teams/personal/spaces/abstract",
         parameters: [
          "space_MUIDs": muids
    ] as AnyObject) { response in
      completion(response.contentDictionary?["caption"] as? String, response.error)
    }
  }
  
  /**
   Method for fetching all accessible spaces.
   
   - parameter lastModelVersion: Last user model version that was fetched (allows diff downlaods)
   - parameter offset: There can be only limited number of spaces in response so pagination offset can be sometimes needed.
   - parameter limit: There can be only limited number of items in response so pagination offset can be sometimes needed.
   - parameter completion: Completion block.
   
   */
  public func pullSpaces(lastModelVersion: Int?,
                         offset: Int?,
                         limit: Int? = nil,
                         completion: @escaping PullOutputs<Space>) {
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
    GET("teams/personal/spaces",
        parameters: parameters) { [weak self] response in
          let items: [Space]? = self?.entitiesFromArray(array: response.content)
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



