
import Foundation
import ObjectMapper

public extension Spaces {
  
  public func getUser(userID: Int?,
                      completion: @escaping (_ user: User?, _ error: Swift.Error?)->()) {
    let id = userID == User.Constants.myselfUserID ? "self" : "\(userID!)"
    GET("users/\(id)",
    parameters: nil) { [weak self] response in
      completion(self?.entityFromDictionary(dictionary: response.dataDictionary?["user"]), response.error)
    }
  }
}
