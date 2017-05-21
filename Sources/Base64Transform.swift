
import Foundation
import ObjectMapper

public class Base64Transform: TransformType {
  
  public typealias Object = Data
  public typealias JSON = String
  
  public init() {}
  
  public func transformFromJSON(_ value: Any?) -> Data? {
    if let string = value as? String {
      let data = Data(base64Encoded: string, options: [.ignoreUnknownCharacters])
      return data
    }
    return nil
  }
  
  public func transformToJSON(_ value: Data?) -> String? {
    if let data = value {
      return data.base64EncodedString(options: [])
    }
    return nil
  }
}
