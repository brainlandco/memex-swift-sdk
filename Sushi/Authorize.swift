

public extension Spaces {
  
  public func authorize(
    credentials: Credentials,
    method: AuthorizationMethod = .userCredentials,
    completion: @escaping VoidOutputs) {
    let completion = { (token: String?, error: Swift.Error?) -> Void in
      if error == nil {
        completion(nil)
      } else {
        completion(error)
      }
    }
    switch method {
    case .userCredentials:
      self.auth.authorizeWithCredentials(credentials: credentials,
                                                          completionHandler: completion)
    case .iCloudToken:
      self.auth.authorizeWithUUID(UUID: credentials.identifier,
                                                   completionHandler: completion)
    }
  }
  
}

