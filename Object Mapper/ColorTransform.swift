
import Foundation

public class ColorTransform: TransformType {
  
  public typealias Object = Color
  public typealias JSON = String
  
  public init() {}
  
  public func transformFromJSON(_ value: Any?) -> Color? {
    if let string = value as? String {
      return Color.colorFromJSColorString(jsColor: string)
    }
    return nil
  }
  
  public func transformToJSON(_ value: Color?) -> String? {
    if let color = value {
      return color.JSColorString()
    }
    return nil
  }
}
