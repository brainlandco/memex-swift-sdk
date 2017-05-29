
import Foundation

public class Response {
  
  public var content: Any?
  public var contentDictionary: [String: Any]? {
    return self.content as? [String: Any]
  }
  public var error: Swift.Error?
  
  public init() {
  }
  
}
