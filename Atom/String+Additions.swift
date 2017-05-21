
import Foundation

extension String {
 
  public func toURL() -> URL? {
    return URL(string: self)
  }
  
  public static func UUID() -> String {
    return NSUUID().uuidString
  }
  
  public func stringWithStrippedHTML() -> String {
    return self.replacingOccurrences(of: "<[^>]+>",
                                     with: "",
                                     options: .regularExpression,
                                    range: nil)
  }
  
}
