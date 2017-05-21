
import Foundation

public extension Spaces {
  
  public func requestBackup(completion: @escaping VoidOutputs) {
    GET("users/self/backup") { response in
      completion(response.error)
    }
  }
  
}



