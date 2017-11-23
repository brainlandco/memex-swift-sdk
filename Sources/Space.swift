
import Foundation
import ObjectMapper

/// Defines known space types
public enum SpaceType: String {
  /// Origin is simillar to collection but defines entry point into users spaces (root)
  case origin = "com.memex.origin"
  /// Collection of links to spaces
  case collection = "com.memex.media.collection"
  /// Space that represents web link
  case webPage = "com.memex.media.webpage"
  /// Graphical kind of space
  case image = "com.memex.media.image"
  /// Textual kind of space
  case text = "com.memex.media.text"
}

/// Object that represents memex space, place that bundles links or atomic media in representation set
public class Space: JSONRepresentable, ObjectProtocol {
  
  /// Unique identifier
  public var MUID: String?
  /// Creation timestamp
  public var createdAt: Date?
  /// Timestamp of last update
  public var updatedAt: Date?
  /// Visibility state
  public var state: ObjectState?
  /// Owner user ID
  public var ownerID: Int?
  /// Type (eg. com.memex.media.collection, etc.)
  public var spaceType: SpaceType?
  /// Caption
  public var caption: String?
  /// Tint color
  public var color: Color?
  /// Set of media that represents space (eg webpage space is represented by url, thumbnail, summary)
  public var representations: [Media]?
  /// Unread flag (if user needs to be notified about changes)
  public var unread: Bool?
  public override var hashValue: Int {
    return self.MUID!.hashValue
  }
  
  public required init() {
    super.init()
  }
  
  public required init?(map: Map) {
    super.init(map: map)
  }
  
  override public func mapping(map: Map) {
    self.MUID <- map["muid"]
    self.createdAt <- map["created_at"]
    self.updatedAt <- map["updated_at"]
    self.state <- map["state"]
    self.ownerID <- map["owner_id"]
    self.spaceType <- map["type_identifier"]
    self.caption <- map["caption"]
    self.color <- map["color"]
    self.representations <- map["representations"]
    self.unread <- map["unread"]
  }
  
}

public func ==(lhs: Space, rhs: Space) -> Bool {
  if lhs.MUID == nil || rhs.MUID == nil {
    return lhs === rhs
  }
  return lhs.MUID == rhs.MUID
}
