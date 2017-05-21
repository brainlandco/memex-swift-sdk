
import Foundation
import ObjectMapper

public class SpaceVisit: JSONRepresentable {
  
  public var spaceMUID: String?
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
