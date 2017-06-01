
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
  
  public func createUser(user: User,
                         onboardingToken: String? = nil,
                         completion: @escaping VoidOutputs) {
    var parameters = [String: Any]()
    parameters["user"] = user.toJSON()
    parameters["onboarding_token"] = onboardingToken
    POST("users", parameters: parameters) { response in
      completion(response.error)
    }
  }
  
  public func getUser(userID: Int?,
                      completion: @escaping (_ user: User?, _ error: Swift.Error?)->()) {
    let id = userID == User.Constants.myselfUserID ? "self" : "\(userID!)"
    GET("users/\(id)",
    parameters: nil) { [weak self] response in
      completion(self?.entityFromDictionary(dictionary: response.contentDictionary?["user"]), response.error)
    }
  }
  
  public func setUserPassword(oldPassword: String?,
                              newPassword: String,
                              completion: @escaping VoidOutputs) {
    var parameters = [String: Any]()
    if let oldPassword = oldPassword {
      parameters["old_password"] = oldPassword
    }
    parameters["new_password"] = newPassword
    POST("users/self/change-password",
         parameters: parameters) { response in
          completion(response.error)
    }
  }
  
  public func requestBackup(completion: @escaping VoidOutputs) {
    GET("users/self/backup") { response in
      completion(response.error)
    }
  }
  
}
