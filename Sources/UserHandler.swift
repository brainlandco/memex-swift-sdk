import Foundation
import ObjectMapper


public extension Spaces {
  
  /**
   User creation. There are two possible ways how to create and authenticate user classical
   using email & password and second using onboarding token that allows to create "anonymous" user
   without email, name, password.
   
   Example of traditional method:
   ```
   let user = new User()
   user.email = "me@host.com"
   user.password = "password"
   memex.createUser(user) { error in
   guard error == nil else {
   // failed
   }
   // succeeded
   }
   
   ```
   
   Example of onboarding token method:
   ```
   let onboardingToken = "Generated and stored or retrieved from icloud"
   let user = new User()
   user.fullname = "Optional Fullname"
   memex.createUser(user, onboardingToken) { error in
   guard error == nil else {
   // failed
   }
   // succeeded
   }
   
   ```
   - parameter user: User object
   - parameter onboardingToken: Onboarding token. This token can be used for authentication.
   - parameter completion: Completion block
   */
  public func createUser(user: User,
                         onboardingToken: String? = nil,
                         completion: @escaping UserOutputs) {
    user.onboardingToken = onboardingToken
    var json = user.toJSON()
    json.removeValue(forKey: "id")
    json.removeValue(forKey: "is_phone_verified")
    json.removeValue(forKey: "is_email_verified")
    json.removeValue(forKey: "updated_at")
    json.removeValue(forKey: "created_at")
    json.removeValue(forKey: "has_password")
    json.removeValue(forKey: "origin_space_muid")
    json.removeValue(forKey: "password_changed_at")
    
    POST("users", parameters: json as AnyObject) { [weak self] response in
      if (response.httpErrorCode == 409) {
        completion(nil, MemexError.alreadyExists)
        return
      }
      completion(self?.entityFromDictionary(dictionary: response.contentDictionary), response.error)
    }
  }
  
  /**
   Returns user object based on his ID.
   
   - parameter userID: User ID (pass nil if you want to get yourself)
   - parameter completion: Completion block
   
   */
  public func getUser(userID: Int?,
                      completion: @escaping UserOutputs) {
    let id = (userID == User.Constants.myselfUserID || userID == nil) ? "self" : "\(userID!)"
    GET("users/\(id)",
    parameters: nil) { [weak self] response in
      completion(self?.entityFromDictionary(dictionary: response.contentDictionary), response.error)
    }
  }
  
  
  /**
   Updates user (only myself). For password change use setUserPassword method.
   
   Example:
   ```
   user.fullname = "New Fullname"
   memex.updateUser(user) { error in
     guard error == nil else {
       // failed
     }
     // succeeded
   }
   
   ```
   
   - parameter user: User object with updated values
   - parameter completion: Completion block
   
   */
  public func updateUser(user: User,
                         completion: @escaping UserOutputs) {
    var userParams = user.toJSON()
    userParams["avatar"] = nil
    if let avatar_muid = user.avatar?.MUID {
      userParams["avatar_muid"] = avatar_muid
    }
    userParams.removeValue(forKey: "id")
    userParams.removeValue(forKey: "updated_at")
    userParams.removeValue(forKey: "created_at")
    userParams.removeValue(forKey: "is_phone_verified")
    userParams.removeValue(forKey: "is_email_verified")
    userParams.removeValue(forKey: "password")
    userParams.removeValue(forKey: "has_password")
    userParams.removeValue(forKey: "origin_space_muid")
    userParams.removeValue(forKey: "password_changed_at")
    userParams.removeValue(forKey: "permissions")
    userParams.removeValue(forKey: "avatar")
    
    POST("users/self",
         parameters: userParams as AnyObject) { [weak self] response in
          completion(self?.entityFromDictionary(dictionary: response.contentDictionary), response.error)
    }
  }
  
  /**
   Sets/changes authenticated user password.
   
   - parameter oldPassword: Must be preset if user.hasPassword is true
   - parameter newPassword: New user password
   - parameter completion: Completion block that returns error if action fails
   
   */
  public func setUserPassword(oldPassword: String?,
                              newPassword: String,
                              completion: @escaping VoidOutputs) {
    var parameters = [String: Any]()
    if let oldPassword = oldPassword {
      parameters["old_password"] = oldPassword
    }
    parameters["new_password"] = newPassword
    POST("users/self/change-password",
         parameters: parameters as AnyObject) { response in
          completion(response.error)
    }
  }
  
  /**
   Request password reset.
   
   - parameter email: Email for request account
   - parameter completion: Completion block that returns error if action fails
   
   */
  public func requestPasswordReset(email: String,
                                   completion: @escaping VoidOutputs) {
    var parameters = [String: Any]()
    parameters["email"] = email
    POST("users/self/request-password-reset",
         parameters: parameters as AnyObject) { response in
          completion(response.error)
    }
  }
  
  /**
   Reset password.
   
   - parameter resetToken: Password reset token that was recevied by email
   - parameter newPassword: New password
   - parameter completion: Completion block that returns error if action fails
   
   */
  public func resetPassword(resetToken: String,
                            newPassword: String,
                            completion: @escaping VoidOutputs) {
    var parameters = [String: Any]()
    parameters["token"] = resetToken
    parameters["new_password"] = newPassword
    POST("users/self/reset-password",
         parameters: parameters as AnyObject) { response in
          completion(response.error)
    }
  }
  
  
  /**
   Request contact verification.
   
   - parameter type: Contact type
   - parameter completion: Completion block that returns error if action fails
   
   */
  public func requestContactVerification(type: ContactType,
                                         completion: @escaping VoidOutputs) {
    var parameters = [String: Any]()
    parameters["type"] = type.rawValue
    POST("users/self/contacts/request-verification",
         parameters: parameters as AnyObject) { response in
          completion(response.error)
    }
  }
  
  /**
   Verify user contact
   
   - parameter type: Contact type
   - parameter verificationToken: Verification token
   - parameter completion: Completion block that returns error if action fails
   
   */
  public func verifyContact(type: ContactType,
                            verificationToken: String,
                            completion: @escaping VoidOutputs) {
    var parameters = [String: Any]()
    parameters["token"] = verificationToken
    parameters["type"] = type.rawValue
    POST("users/self/contacts/verify",
         parameters: parameters as AnyObject) { response in
          completion(response.error)
    }
  }
  
  /**
   Requests user backup. If this method requires to have setup email.
   
   - parameter completion: Completion block that returns error if action fails
   
   */
  public func requestBackup(notify: Bool, copyTargetType: String?,
    copyTargetSecret: String?, completion: @escaping VoidOutputs) {
    var parameters = [String: Any]()
    parameters["should_notify"] = notify
    if copyTargetType != nil {
      parameters["copy_target"] = [
        "type": copyTargetType,
        "secret": copyTargetSecret,
      ]
    }
    POST("users/self/exports",
         parameters: parameters as AnyObject) { response in
      completion(response.error)
    }
  }
  
  /**
   Sets copy target for export.
   
   - parameter id: Export id
   - parameter type: Type of target (eg. dropbox)
   - parameter secret: Access token to target service
   - parameter completion: Completion block that returns error if action fails
   
   */
  public func setExportCopyTarget(id: Int, type: String, secret: String,
                                  completion: @escaping VoidOutputs) {
    var parameters = [String: Any]()
    parameters["type"] = type
    parameters["secret"] = secret
    POST("users/self/exports/\(id)/copy-target", parameters: parameters as AnyObject) { response in
      completion(response.error)
    }
  }

  
}
