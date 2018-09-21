
import Foundation
import ObjectMapper

/// Object that represents user session/login
public class Session: JSONRepresentable {
  

  /// Unique identifier
  public var ID: Int?
  /// Creation timestamp
  public var createdAt: Date?
  /// Is Current User Session?
  public var isCurrent: Bool?
  /// Visibility state
  public var IP: String?
  /// Owner user ID
  public var browser: String?
  /// Index that is used for sorting of links in space
  public var os: String?
  /// Origin space MUID
  public var device: String?
  public override var hash: Int {
    return self.ID!.hashValue
  }
  
  public required init() {
    super.init()
  }
  
  public required init?(map: Map) {
    super.init(map: map)
  }
  
  override public func mapping(map: Map) {
    self.ID <- map["id"]
    self.os <- map["os"]
    self.device <- map["device"]
    self.browser <- map["browser"]
    self.createdAt <- map["created_at"]
    self.IP <- map["ip"]
    self.isCurrent <- map["is_current"]
  }
  
}

public func ==(lhs: Session, rhs: Session) -> Bool {
  if lhs.ID == nil || rhs.ID == nil {
    return lhs === rhs
  }
  return lhs.ID == rhs.ID
}


