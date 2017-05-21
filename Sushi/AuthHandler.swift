

public extension Spaces {
  
  public func loginUserWithCredentials(
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
  
  public func loginUserWithiCloud(
    token: String,
    completion: @escaping VoidOutputs) {
    let completion = { (token: String?, error: Swift.Error?) -> Void in
      if error == nil {
        completion(nil)
      } else {
        completion(error)
      }
    }
    self.auth.authorizeWithUUID(UUID: token,
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

