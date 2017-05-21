
import Foundation
import ObjectMapper

public extension Spaces {
  
  public func logSpaceVisits(visits: [SpaceVisit],
                             completion: @escaping VoidOutputs) {
    POST("spaces/log-visits",
         parameters: [
          "spaces": Mapper<SpaceVisit>().toJSONArray(visits)
    ]) { response in
      completion(response.error)
    }
  }
  
}
