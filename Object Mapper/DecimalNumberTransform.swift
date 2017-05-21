
import Foundation

public class DecimalNumberTransform: TransformType {
  
  public typealias Object = NSDecimalNumber
  public typealias JSON = Any
  
  public init() {}
  
  public func transformFromJSON(_ value: Any?) -> NSDecimalNumber? {
    if let value = value {
      let string = "\(value)"
      return NSDecimalNumber(string: string)
    }
    return nil
  }
  
  public func transformToJSON(_ value: NSDecimalNumber?) -> Any? {
    if let value = value {
      return value.stringValue as AnyObject?
    }
    return nil
  }
}
