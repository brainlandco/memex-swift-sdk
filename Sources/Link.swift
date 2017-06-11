
import Foundation
import ObjectMapper

/// Object that represents oriented link between two spaces
public class Link: JSONRepresentable, ObjectProtocol {
  
  /// Unique identifier
  public var MUID: String?
  /// Creation timestamp
  public var createdAt: Date?
  /// Timestamp of last update
  public var updatedAt: Date?
  /// Timestamp of last visit
  public var visitedAt: Date?
  /// Visibility state
  public var state: ObjectState?
  /// Owner user ID
  public var ownerID: Int?
  /// Index that is used for sorting of links in space
  public var order: Int?
  /// Origin space MUID
  public var originSpaceMUID: String?
  /// Target space MUID
  public var targetSpaceMUID: String?
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
    self.order <- map["order"]
    self.originSpaceMUID <- map["origin_space_muid"]
    self.targetSpaceMUID <- map["target_space_muid"]
  }
  
}

public func ==(lhs: Link, rhs: Link) -> Bool {
  if lhs.MUID == nil || rhs.MUID == nil {
    return lhs === rhs
  }
  return lhs.MUID == rhs.MUID
}

