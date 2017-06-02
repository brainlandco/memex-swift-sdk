
import Foundation
import ObjectMapper

class BytesCountTransform: TransformType {
  
  typealias Object = Int64
  typealias JSON = NSNumber
  
  init() {
  }
  
  func transformFromJSON(_ value: Any?) -> Int64? {
    if let number = value as? NSNumber {
      return number.int64Value
    } else {
      return nil
    }
  }
  
  func transformToJSON(_ value: Int64?) -> NSNumber? {
    if let number = value {
      return NSNumber(value: number)
    }
    return nil
  }
}
