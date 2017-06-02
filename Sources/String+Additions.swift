
import Foundation

extension String {
 
  func toURL() -> URL? {
    return URL(string: self)
  }
  
  static func UUID() -> String {
    return NSUUID().uuidString
  }
  
  func stringWithStrippedHTML() -> String {
    return self.replacingOccurrences(of: "<[^>]+>",
                                     with: "",
                                     options: .regularExpression,
                                    range: nil)
  }
  
}
