
import Foundation
import ObjectMapper

public class Link: JSONRepresentable, ObjectProtocol {
  
  public var MUID: String?
  public override var hashValue: Int {
    return self.MUID!.hashValue
  }
  public var createdAt: Date?
  public var updatedAt: Date?
  public var state: ObjectState?
  public var ownerID: Int?
  public var order: Int?
  public var tagLabel: String?
  public var originSpaceMUID: String?
  public var targetSpaceMUID: String?
  
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
    self.tagLabel <- map["tag_label"]
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

