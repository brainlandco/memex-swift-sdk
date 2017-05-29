
import Foundation
import ObjectMapper

public typealias PullMediaOutputs = (
  _ items: [Media]?,
  _ modelVersion: Int?,
  _ totalItems: Int?,
  _ hasMore: Bool?,
  _ nextOffset: Int?,
  _ error: Swift.Error?)->()


public extension Spaces {
  
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
  
  public func pushMedia(items: [Media],
                        completion: @escaping PushOutputs) {
    POST("media/multiple",
         parameters:["media": items.toJSON()]) { response in
          let oldModelVersion = response.contentDictionary?["old_model_version"] as? Int
          let modelVersion = response.contentDictionary?["model_version"] as? Int
          completion(oldModelVersion, modelVersion, response.error)
    }
  }
  
  public func pullMedia(lastModelVersion: Int?,
                        offset: Int?,
                        completion: @escaping PullMediaOutputs) {
    var parameters = [String: Any]()
    if let value = lastModelVersion {
      parameters["last_model_version"] = value
    }
    if let value = offset {
      parameters["offset"] = value
    }
    GET("users/self/media",
        parameters: parameters) { [weak self] response in
          let items: [Media]? = self?.entitiesFromArray(array: response.contentDictionary?["media"])
          let modelVersion = response.contentDictionary?["model_version"] as? Int
          let totalItems = response.contentDictionary?["total"] as? Int
          let hasMore = response.contentDictionary?["has_more"] as? Bool
          let nextOffset = response.contentDictionary?["next_offset"] as? Int
          completion(items, modelVersion, totalItems, hasMore, nextOffset, response.error)
    }
  }
  
  public func getMedia(media: Media,
                       completion: @escaping (_ media: Media?, _ error: Swift.Error?)->()) {
    GET("media/\(media.MUID!)") { [weak self] response in
      completion(self?.entityFromDictionary(dictionary: response.contentDictionary?["media"]), response.error)
    }
  }
  
  public func markMediaAsUploaded(media: Media,
                                  completion: @escaping VoidOutputs) {
    POST("media/\(media.MUID!)") { response in
      completion(response.error)
    }
  }
  
}
