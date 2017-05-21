
import Foundation

public class EncodedJSONTransform: TransformType {
  
  public typealias Object = [String: Any]
  public typealias JSON = String
  
  public init() {}
  
  public func transformFromJSON(_ value: Any?) -> [String: Any]? {
    if let string = value as? String {
      do {
        let data = string.data(using: String.Encoding.utf8)!
        let object = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        return object
      }
      catch {
        return nil
      }
    }
    return nil
  }
  
  public func transformToJSON(_ value: [String: Any]?) -> String? {
    if let value = value {
      let data = try! JSONSerialization.data(withJSONObject: value, options: [])
      let string = String(data: data, encoding: String.Encoding.utf8)
      return string
    }
    return nil
  }
  
}
