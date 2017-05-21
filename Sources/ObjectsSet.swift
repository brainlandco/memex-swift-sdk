
import Foundation
import ObjectMapper

public protocol ObjectProtocol: Hashable {
  var MUID: String? { get }
  var updatedAt: Date? { get }
}

public class ObjectsSet: JSONRepresentable {

  public var media: [Media]?
  public var spaces: [Space]?
  public var links: [Link]?
  
  public required init() {
    super.init()
  }
  
  public required init?(map: Map) {
    super.init(map: map)
  }
  
  override public func mapping(map: Map) {
    super.mapping(map: map)
    
    self.media <- map["media"]
    self.spaces <- map["spaces"]
    self.links <- map["links"]
  }
  
}
