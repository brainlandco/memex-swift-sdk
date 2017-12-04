
import Foundation
import ObjectMapper

/// Object that represents user security audit
public class UserSecurityAudit: JSONRepresentable {

  public var warnings: [String]?
  public var errors: [String]?
  
  public required init() {
    super.init()
  }
  
  public required init?(map: Map) {
    super.init(map: map)
  }
  
  override public func mapping(map: Map) {
    self.warnings <- map["warnings"]
    self.errors <- map["errors"]
  }
  
}
