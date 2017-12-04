
import Foundation
import ObjectMapper

/// Object that represents export job
public class Export: JSONRepresentable {
  
  public var id: Int?
  
  public required init() {
    super.init()
  }
  
  public required init?(map: Map) {
    super.init(map: map)
  }
  
  override public func mapping(map: Map) {
    self.id <- map["id"]
  }
  
}

