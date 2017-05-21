
import Foundation
import ObjectMapper

public extension Spaces {
  
  public func processSpace(MUID: String,
                           completion: @escaping VoidOutputs) {
    POST("spaces/\(MUID)/process") { response in
      completion(response.error)
    }
  }

}
