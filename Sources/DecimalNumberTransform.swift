
import Foundation
import ObjectMapper

class DecimalNumberTransform: TransformType {
  
  typealias Object = NSDecimalNumber
  typealias JSON = Any
  
  init() {}
  
  func transformFromJSON(_ value: Any?) -> NSDecimalNumber? {
    if let value = value {
      let string = "\(value)"
      return NSDecimalNumber(string: string)
    }
    return nil
  }
  
  func transformToJSON(_ value: NSDecimalNumber?) -> Any? {
    if let value = value {
      return value.stringValue as AnyObject?
    }
    return nil
  }
}
