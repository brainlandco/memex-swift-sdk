
public extension Spaces {
  
  public func deauthorize(
    completion: VoidOutputs) {
    self.auth.deauthorize()
    completion(nil)
  }
  
}


