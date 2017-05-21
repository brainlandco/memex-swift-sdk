
import Foundation
import ObjectMapper

public extension Spaces {
  
  public func updateUser(user: User,
                         completion: @escaping VoidOutputs) {
    var userParams = Mapper<User>().toJSON(user)
    userParams["avatar"] = nil
    if let avatar_muid = user.avatar?.MUID {
      userParams["avatar_muid"] = avatar_muid
    }
    POST("users/self",
         parameters: ["user": userParams]) { response in
          completion(response.error)
    }
  }
  
}
