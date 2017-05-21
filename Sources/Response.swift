
import Foundation

public class Response {
  
  public var content: Any?
  public var contentDictionary: [String: Any]? {
    return self.data as? [String: Any]
  }
  public var data: Any?
  public var dataDictionary: [String: Any]? {
    return self.data as? [String: Any]
  }
  public var metadata: [String: Any]?
  public var error: Swift.Error?
  
  public init() {
  }
  
}
