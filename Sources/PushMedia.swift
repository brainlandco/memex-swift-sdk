
import Foundation
import ObjectMapper

public extension Spaces {
  
  public func pushMedia(items: [Media],
                        completion: @escaping PushOutputs) {
    POST("media/batched",
         parameters:["data": items.toJSON()]) { response in
          let oldModelVersion = response.metadata?["old_model_version"] as? Int
          let modelVersion = response.metadata?["model_version"] as? Int
          completion(oldModelVersion, modelVersion, response.error)
    }
  }
  
}



