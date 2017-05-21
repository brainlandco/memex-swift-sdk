
import Foundation
import ObjectMapper

public typealias PushOutputs = (
  _ oldModelVersion: Int?,
  _ modelVersion: Int?,
  _ error: Swift.Error?)->()

public extension Spaces {
  
  public func pushSpaces(items: [Space],
                         completion: @escaping PushOutputs) {
    POST("spaces/batched",
         parameters:["data": items.toJSON()]) { response in
          let oldModelVersion = response.metadata?["old_model_version"] as? Int
          let modelVersion = response.metadata?["model_version"] as? Int
          completion(oldModelVersion, modelVersion, response.error)
    }
  }
  
}



