
import Foundation
import ObjectMapper

public extension Spaces {
  
  public func getMedia(media: Media,
                       completion: @escaping (_ media: Media?, _ error: Swift.Error?)->()) {
    GET("media/\(media.MUID!)") { [weak self] response in
      completion(self?.entityFromDictionary(dictionary: response.dataDictionary?["media"]), response.error)
    }
  }
  
}
