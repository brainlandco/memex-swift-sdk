import Foundation
import ObjectMapper


/**
 Response of sessions
 
 - parameter items: Set of sessions
 - parameter error: Error if something wrong happens
 
 */
public typealias SessionsMessage = (
  _ items: [Session]?,
  _ error: Swift.Error?)->()

public extension Spaces {
  
  /**
   Method for fetching all us.er sessions
   
   - parameter completion: Completion block.
   
   */
  public func getSessions(completion: @escaping SessionsMessage) {
    GET("users/self/sessions") { [weak self] response in
      let items: [Session]? = self?.entitiesFromArray(array: response.content)
      completion(items, response.error)
    }
  }
  
}




