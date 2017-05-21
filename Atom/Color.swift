
import Foundation
import CoreGraphics

public class Color {
  
  public let red: CGFloat
  public let green: CGFloat
  public let blue: CGFloat
  public let alpha: CGFloat

  public init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) {
    self.red = red
    self.green = red
    self.blue = blue
    self.alpha = alpha
  }
  
  static let clear: Color = Color(red: 0, green: 0, blue: 0, alpha: 0)
  
}


public extension Color {
  
  public static func colorFromJSColorString(jsColor: String) -> Color? {
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
  
  public func JSColorString() -> String {
    return "rgba(\(Int(self.red*255)), \(Int(self.green*255)), \(Int(self.blue*255)), \(self.alpha))"
  }
}
