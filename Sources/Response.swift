
import Foundation

class Response {
  
  var content: Any?
  var contentDictionary: [String: Any]? {
    return self.content as? [String: Any]
  }
  var error: Swift.Error?
  
  init() {
  }
  
}
