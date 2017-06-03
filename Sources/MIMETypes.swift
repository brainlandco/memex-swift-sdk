
import Foundation

/// Structure that defines various type of MIME types
public struct MIMETypes {
  
  /// Plain text mime type
  public static let Text = "text/plain"
  public static let ImagePNG = "image/png"
  public static let ImageJPEG = "image/jpeg"
  public static let ImageGIF = "image/gif"
  public static let Sketch = "image/sketch"
  public static let JSON = "application/json"
  public static let PDF = "application/pdf"
  
  /// Determines mime type based on file extension (eg. .json -> application/json)
  public static func mimeTypeFromExtension(fileExtension: String) -> String? {
    switch fileExtension {
    case "txt":
      return self.Text
    case "sketch":
      return self.Sketch
    case "png":
      return self.ImagePNG
    case "gif":
      return self.ImageGIF
    case "jpg":
      return self.ImageJPEG
    case "jpeg":
      return self.ImageJPEG
    case "json":
      return self.JSON
    default:
      return nil
    }
  }
  
  /// Provides human readable names for mime types
  public static func captionFromType(string: String) -> String? {
    switch string {
    case self.Text:
      return NSLocalizedString("Text", comment: "")
    case self.Sketch:
      return NSLocalizedString("Sketch Image", comment: "")
    case self.ImagePNG:
      return NSLocalizedString("PNG Image", comment: "")
    case self.ImageGIF:
      return NSLocalizedString("GIF Animated Image", comment: "")
    case self.ImageJPEG:
      return NSLocalizedString("JPEG Image", comment: "")
    case self.JSON:
      return NSLocalizedString("JSON Data", comment: "")
    default:
      return nil
    }
  }
}
