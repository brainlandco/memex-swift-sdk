
import Foundation
import ObjectMapper

class Base64Transform: TransformType {
  
  typealias Object = Data
  typealias JSON = String
  
  init() {}
  
  func transformFromJSON(_ value: Any?) -> Data? {
    if let string = value as? String {
      let data = Data(base64Encoded: string, options: [.ignoreUnknownCharacters])
      return data
    }
    return nil
  }
  
  func transformToJSON(_ value: Data?) -> String? {
    if let data = value {
      return data.base64EncodedString(options: [])
    }
    return nil
  }
}
