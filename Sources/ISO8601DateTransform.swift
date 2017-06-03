
import Foundation
import ObjectMapper

class ISO8601DateTransform: TransformType {
  
  typealias Object = Date
  typealias JSON = String

  static let standardDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    return formatter
  }()
  static let decimalDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    return formatter
  }()
  
  init() {
  }
  
  func transformFromJSON(_ value: Any?) -> Date? {
    if let dateString = value as? String {
      if let date = ISO8601DateTransform.decimalDateFormatter.date(from: dateString) {
        return date
      } else {
        return ISO8601DateTransform.standardDateFormatter.date(from: dateString)
      }
    }
    return nil
  }
  
  func transformToJSON(_ value: Date?) -> String? {
    if let date = value {
      return ISO8601DateTransform.decimalDateFormatter.string(from: date)
    }
    return nil
  }
}
