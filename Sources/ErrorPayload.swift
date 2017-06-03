import Foundation
import ObjectMapper

class ErrorPayload: NSObject, Mappable {
  
  var code: Int?
  var message: String?
  
  init(code: Int, message: String) {
    self.code = code
    self.message = message
  }
  
  required init?(map: Map) { super.init() }
  
  func mapping(map: Map) {
    self.code <- map["code"]
    self.message <- map["message"]
  }
  
}
