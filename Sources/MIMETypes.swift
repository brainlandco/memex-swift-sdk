
import Foundation

public struct MIMETypes {
  
  public static let Text = "text/plain"
  public static let ImagePNG = "image/png"
  public static let ImageJPEG = "image/jpeg"
  public static let ImageGIF = "image/gif"
  public static let Sketch = "image/sketch"
  public static let JSON = "application/json"
  public static let PDF = "application/pdf"
  public static let MSWord = "application/msword"
  public static let MSExcel = "application/x-xls"
  public static let MSExcel2 = "application/vnd.ms-excel.sheet.macroenabled.12"
  public static let MSExcel3 = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
  public static let MSPowerpoint = "application/vnd.openxmlformats-officedocument.presentationml.presentation"
  
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
