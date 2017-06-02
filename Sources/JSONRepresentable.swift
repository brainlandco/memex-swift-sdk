
import Foundation
import ObjectMapper

public protocol JSONRepresentableProtocol {
  init()
}

/// Base entity object
open class JSONRepresentable: NSObject, Mappable, JSONRepresentableProtocol {
  
  public required override init() {
  }
  
  public required init?(map: Map) {
  }
  
  open func mapping(map: Map) {
  }
  
  public var dictionaryRepresentation: [String: Any] {
    return Mapper().toJSON(self)
  }
}
