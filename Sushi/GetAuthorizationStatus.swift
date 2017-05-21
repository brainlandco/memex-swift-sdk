
public extension Spaces {
  
  typealias Outputs = (_ userToken: String?, _ error: Error?)->()
  
  public func getUserToken(completion: Outputs) {
    completion(self.auth.userToken, nil)
  }
  
}
