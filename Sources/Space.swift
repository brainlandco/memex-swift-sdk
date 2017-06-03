
import Foundation
import ObjectMapper

/// Object that represents memex space, place that bundles links or atomic media in representation set
public class Space: JSONRepresentable, ObjectProtocol {
  
  /// Space unique identifier
  public var MUID: String?
  /// Timestamp of space creation
  public var createdAt: Date?
  /// Timestamp of last change of space
  public var updatedAt: Date?
  /// Visibility state of space
  public var state: ObjectState?
  /// Caption of space
  public var caption: String?
  /// Tint color of space
  public var color: Color?
  /// Type identifier of space, (eg. com.memex.media.collection)
  public var typeIdentifier: String?
  /// Flag if space was seen or not
  public var unread: Bool?
  /// Owner user ID
  public var ownerID: Int?
  /// Set of media that represents space (eg webpage space is represented by url, thumbnail, summary)
  public var representations: [Media]?
  /// Latitude of place where was object created
  public var latitude: Double?
  /// Longitude of place where was object created
  public var longitude: Double?
  /// Activity vector (vector)
  public var activity: Int?
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
    self.caption <- map["tag_label"]
    self.latitude <- map["latitude"]
    self.longitude <- map["longitude"]
    self.activity <- map["activity"]
    self.unread <- map["unread"]
    self.color <- map["tag_color"]
    self.typeIdentifier <- map["type_identifier"]
    self.ownerID <- map["owner_id"]
  }
  
}

public func ==(lhs: Space, rhs: Space) -> Bool {
  if lhs.MUID == nil || rhs.MUID == nil {
    return lhs === rhs
  }
  return lhs.MUID == rhs.MUID
}
