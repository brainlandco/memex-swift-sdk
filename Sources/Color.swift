
import Foundation
import CoreGraphics

/**
 
 Universal color object that can be converted into
 
 Here is example how to convert Color into UIColor
 ```
 let uiColor = UIColor(red: mememxColor.red, green: mememxColor.green, blue: mememxColor.blue, alpha: mememxColor.alpha)
 ```
 
 */
public class Color {
  
  /// Red component (in range 0..1)
  public let red: CGFloat
  /// Green component (in range 0..1)
  public let green: CGFloat
  /// Blue component (in range 0..1)
  public let blue: CGFloat
  /// Alpha component (in range 0..1)
  public let alpha: CGFloat
  
  public init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) {
    self.red = red
    self.green = green
    self.blue = blue
    self.alpha = alpha
  }
  
  static let clear: Color = Color(red: 0, green: 0, blue: 0, alpha: 0)
  
}

