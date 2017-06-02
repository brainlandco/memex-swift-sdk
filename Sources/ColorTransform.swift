
import Foundation
import ObjectMapper

class ColorTransform: TransformType {
  
  typealias Object = Color
  typealias JSON = String
  
  init() {}
  
  func transformFromJSON(_ value: Any?) -> Color? {
    if let string = value as? String {
      return Color.colorFromJSColorString(jsColor: string)
    }
    return nil
  }
  
  func transformToJSON(_ value: Color?) -> String? {
    if let color = value {
      return color.JSColorString()
    }
    return nil
  }
}

extension Color {
  
  static func colorFromJSColorString(jsColor: String) -> Color? {
    if jsColor.isEmpty {
      return nil
    } else {
      if jsColor == "transparent" {
        return Color.clear
      } else {
        let components = jsColor.components(separatedBy: ",")
        let set = CharacterSet(charactersIn: "rgba() ")
        var red = Float(components[0].trimmingCharacters(in: set))!
        if red > 1 {
          red = red/255.0
        }
        var green = Float(components[1].trimmingCharacters(in: set))!
        if green > 1 {
          green = green/255.0
        }
        var blue = Float(components[2].trimmingCharacters(in: set))!
        if blue > 1 {
          blue = blue/255.0
        }
        var alpha: Float = 1
        if components.count == 4 {
          alpha = Float(components[3].trimmingCharacters(in: set))!
        }
        return Color(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
      }
    }
  }
  
  func JSColorString() -> String {
    return "rgba(\(Int(self.red*255)), \(Int(self.green*255)), \(Int(self.blue*255)), \(self.alpha))"
  }
}
