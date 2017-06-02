
import Foundation
import ObjectMapper

/// Defines object that describes each visit of space
public class SpaceVisit: JSONRepresentable {
  
  /// MUID of space that was visited
  public var spaceMUID: String?
  
  /// Timestamp of visit
  public var visitedAt: Date?
  
  public required init() {
    super.init()
  }
  
  public required init?(map: Map) {
    super.init(map: map)
  }
  
  override public func mapping(map: Map) {
    super.mapping(map: map)
    
    self.spaceMUID <- map["muid"]
    self.visitedAt <- map["visited_at"]
  }
  
}
