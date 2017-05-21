
import Foundation
import ObjectMapper

public extension Spaces {
  
  public func createUser(user: User,
                         completion: @escaping VoidOutputs) {
    var parameters = [String: Any]()
    parameters["user"] = user.toJSON()
    POST("users", parameters: parameters) { response in
      completion(response.error)
    }
  }
  
}
