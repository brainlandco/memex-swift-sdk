
import Foundation
import ObjectMapper

public extension Spaces {
  
  public func createMedia(media: Media,
                          completion: @escaping (_ media: Media?, _ error: Swift.Error?)->()) {
    POST("media",
         parameters: [
          "media": Mapper<Media>().toJSON(media)
    ]) { [weak self] response in
      completion(self?.entityFromDictionary(dictionary: response.dataDictionary?["media"]),
                 response.error)
    }
  }
}
