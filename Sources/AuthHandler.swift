

public extension Spaces {
  
  /**
   Authenticate user with credentials (email and password).
   
   Following example shows how to use this method:
   
   ```
   let credentials = new Credentials("email@host.com","secretPASSWORD")
   memex.loginUserWithUserCredentials(credentials) { error in
     guard error == nil else {
       // login failed
     }
     // login succeeded
   }
   
   ```
   
   - parameters:
     - credentials: Object that contains pair of email and password.
     - completion: Completion block that returns error if something wrong happens.
   
   - returns: Returns removed object. If there is any, otherwise it returns nil.
   
   */
  public func loginUserWithUserCredentials(
    credentials: Credentials,
    completion: @escaping VoidOutputs) {
    let completion = { (token: String?, error: Swift.Error?) -> Void in
      if error == nil {
        completion(nil)
      } else {
        completion(error)
      }
    }
    self.auth.authorizeWithCredentials(credentials: credentials,
                                       completionHandler: completion)
  }
  
  public func loginUserWithOnboardingToken(
    token: String,
    completion: @escaping VoidOutputs) {
    let completion = { (token: String?, error: Swift.Error?) -> Void in
      if error == nil {
        completion(nil)
      } else {
        completion(error)
      }
    }
    self.auth.authorizeWithOnboardingToken(token: token,
                                           completionHandler: completion)
  }
  
  public func logout(
    completion: VoidOutputs) {
    self.auth.deauthorize()
    completion(nil)
  }

  public func isLoggedIn(completion: (_ loggedIn: Bool?, _ error: Error?)->()) {
    completion(self.auth.userToken != nil, nil)
  }
  
}

