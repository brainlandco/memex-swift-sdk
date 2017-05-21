
import Foundation
import ObjectMapper
import Atom
import CoreGraphics

public class WebpageMetadata: JSONRepresentable {
  
  public var title: String?
  public var summary: String?
  public var tintColor: Color?
  public var thumbnailURL: URL?
  public var thumbnailWidth: CGFloat?
  public var thumbnailHeight: CGFloat?
  
  public required init() {
    super.init()
  }
  
  public required init?(map: Map) {
    super.init(map: map)
  }
  
  override public func mapping(map: Map) {
    super.mapping(map: map)
    self.title <- map["caption"]
    self.summary <- map["preview_text"]
    self.tintColor <- map["tint_color"]
    self.thumbnailURL <- map["preview_url"]
    self.thumbnailWidth <- map["preview_width"]
    self.thumbnailHeight <- map["preview_height"]
  }
  
}
