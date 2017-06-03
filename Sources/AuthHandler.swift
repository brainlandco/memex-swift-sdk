

public extension Spaces {
  
  /**
   Authenticate user with credentials (email and password). Method will request user token and store it in KeyChain.
   
   Example:
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
  
  
  /**
   This method allows client to login with onboarding token. Method will request user token and store it in KeyChain.
   
   Example:
   ```
   memex.loginUserWithOnboardingToken("YourOnboardingToken") { error in
     guard error == nil else {
       // login failed
     }
     // login succeeded
   }
   
   ```
   
   - parameter token: Onboarding token that is generated on client or provided from icloud
   - parameter completion: Completion block that returns error if something wrong happens.
   
   */
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
  
  
  /**
   This method log out authenticated user. It removes user token from Keychain.
   
   - parameter completion: Completion block that returns error if something wrong happens.
   */
  public func logout(
    completion: VoidOutputs) {
    self.auth.deauthorize()
    completion(nil)
  }

  
  /**
   This method log out authenticated user. It removes user token from Keychain.
   
   - parameter completion: Completion block provides user authentication status (true if user authentication token is present) and error message if something went wrong.
   - parameter loggedIn: True if user is logged in
   - parameter error: Error message
   */
  public func isLoggedIn(completion: (_ loggedIn: Bool?, _ error: Error?)->()) {
    completion(self.auth.userToken != nil, nil)
  }
  
}

