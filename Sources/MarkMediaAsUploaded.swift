
import Foundation
import ObjectMapper

public extension Spaces {
  
  public func markMediaAsUploaded(media: Media,
                                  completion: @escaping VoidOutputs) {
    POST("media/\(media.MUID!)") { response in
      completion(response.error)
    }
  }
  
}
