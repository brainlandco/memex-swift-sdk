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
  public func createMedia(media: [Media],
                          removeToken: String? = nil,
                          completion: @escaping PushOutputs<Media>) {
    
    var headers = [String: String]()
    if let value = removeToken {
      headers[HTTPHeader.removeTokenHeader] = value
    }
    
    let array = media.map { item -> AnyObject in
      return item.toJSON() as AnyObject
    }
    
    POST("teams/personal/media", parameters:array as AnyObject, headers: headers) { [weak self] response in
      var oldModelVersion: Int?
      if let value = response.headers?[HTTPHeader.previousModelVersionHeader] {
        oldModelVersion = Int(value as! String)
      }
      var modelVersion: Int?
      if let value = response.headers?[HTTPHeader.modelVersionHeader] {
        modelVersion = Int(value as! String)
      }
      let media: [Media]? = self?.entitiesFromArray(array: response.content)
      completion(media, oldModelVersion, modelVersion, response.error)
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
    GET("teams/personal/media/\(mediaMUID)") { [weak self] response in
      completion(self?.entityFromDictionary(dictionary: response.contentDictionary), response.error)
    }
  }
  
  /**
   Marks media data as uploaded. It means that data was uploaded to dataUploadURL and dataState now can change to valid state.
   
   - parameter mediaMUID: Media MUID.
   - parameter completion: Completion block with error if operation cant be finished.
   
   */
  public func markMediaAsUploaded(mediaMUID: String,
                                  completion: @escaping VoidOutputs) {
    POST("teams/personal/media/\(mediaMUID)/set-as-valid-data") { response in
      completion(response.error)
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
    GET("teams/personal/media",
        parameters: parameters) { [weak self] response in
          let items: [Media]? = self?.entitiesFromArray(array: response.content)
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
