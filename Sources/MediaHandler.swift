import Foundation
import ObjectMapper


public extension Spaces {
  
  /**
   New media creation. If there is some data that needs to be uploaded put it to dataUploadURL and call markMediaAsUploaded.
   
   - parameter media: New media object
   - parameter completion: Completion block
   - parameter media: Media object with valid dataUploadURL
   - parameter error: Error if something wrong happens
   
   */
  public func createMedia(media: Media,
                          completion: @escaping (_ media: Media?, _ error: Swift.Error?)->()) {
    POST("media",
         parameters: [
          "media": Mapper<Media>().toJSON(media)
    ]) { [weak self] response in
      completion(self?.entityFromDictionary(dictionary: response.contentDictionary?["media"]),
                 response.error)
    }
  }
  
  /**
   Returns media object. It can be used when dataDownloadURL is expired and new is needed.
   
   - parameter mediaMUID: Media MUID.
   - parameter completion: Completion block.
   - parameter media: Renewed media object
   - parameter error: Error if something wrong happens
   
   */
  public func getMedia(mediaMUID: String,
                       completion: @escaping (_ media: Media?, _ error: Swift.Error?)->()) {
    GET("media/\(mediaMUID)") { [weak self] response in
      completion(self?.entityFromDictionary(dictionary: response.contentDictionary?["media"]), response.error)
    }
  }
  
  /**
   Marks media data as uploaded. It means that data was uploaded to dataUploadURL and dataState now can change to valid state.
   
   - parameter mediaMUID: Media MUID.
   - parameter completion: Completion block with error if operation cant be finished.
   
   */
  public func markMediaAsUploaded(mediaMUID: String,
                                  completion: @escaping VoidOutputs) {
    POST("media/\(mediaMUID)/mark-as-uploaded") { response in
      completion(response.error)
    }
  }
  
  /**
   This method allows you to sync multiple media.
   
   - parameter items: Set of new or changed links
   - parameter removeToken: Entities can have assigned remove token and it can be used to easily remove them before they are replaced by another ones
   - parameter completion: Completion block
   
   */
  public func pushMedia(items: [Media],
                        removeToken: String? = nil,
                        completion: @escaping PushOutputs) {
    var parameters = [String: Any]()
    parameters["media"] = items.toJSON()
    if let value = removeToken {
      parameters["remove_token"] = value
    }
    POST("media/multiple", parameters:parameters) { response in
      let oldModelVersion = response.contentDictionary?["old_model_version"] as? Int
      let modelVersion = response.contentDictionary?["model_version"] as? Int
      completion(oldModelVersion, modelVersion, response.error)
    }
  }
  
  /**
   Method for fetching all accessible media.
   
   - parameter lastModelVersion: Last user model version that was fetched (allows diff downlaods)
   - parameter offset: There can be only limited number of items in response so pagination offset can be sometimes needed.
   - parameter limit: There can be only limited number of items in response so pagination offset can be sometimes needed.
   - parameter completion: Completion block.
   
   */
  public func pullMedia(lastModelVersion: Int?,
                        offset: Int?,
                        limit: Int? = nil,
                        completion: @escaping PullOutputs<Media>) {
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
    GET("media",
        parameters: parameters) { [weak self] response in
          let items: [Media]? = self?.entitiesFromArray(array: response.contentDictionary?["media"])
          let modelVersion = response.contentDictionary?["model_version"] as? Int
          let totalItems = response.contentDictionary?["total"] as? Int
          let hasMore = response.contentDictionary?["has_more"] as? Bool
          let nextOffset = response.contentDictionary?["next_offset"] as? Int
          completion(items, modelVersion, totalItems, hasMore, nextOffset, response.error)
    }
  }

}
