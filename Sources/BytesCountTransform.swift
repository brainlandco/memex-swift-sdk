
import Foundation
import ObjectMapper

public class BytesCountTransform: TransformType {
  
  public typealias Object = Int64
  public typealias JSON = NSNumber
  
  public init() {
  }
  
  public func transformFromJSON(_ value: Any?) -> Int64? {
    if let number = value as? NSNumber {
      return number.int64Value
    } else {
      return nil
    }
  }
  
  public func transformToJSON(_ value: Int64?) -> NSNumber? {
    if let number = value {
      return NSNumber(value: number)
    }
    return nil
  }
}
