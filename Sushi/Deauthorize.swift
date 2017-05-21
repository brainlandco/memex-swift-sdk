
public extension Service {
  
  public func deauthorize(
    completion: VoidOutputs) {
    self.auth.deauthorize()
    completion(nil)
  }
  
}


