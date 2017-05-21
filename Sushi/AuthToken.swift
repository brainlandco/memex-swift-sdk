
import Foundation
import ObjectMapper

class AuthToken: NSObject, Mappable {
  
  var secret: String?
  var type: String?
  var scope: String?
  var permissions: Permissions {
    var permissions = Permissions.none
    let array = self.scope!.components(separatedBy: " ")
    for value in array {
      if value == "public" {
        permissions.insert(Permissions.publicAccess)
      } else if value == "user_read" {
        permissions.insert(Permissions.userRead)
      } else if value == "user_write" {
        permissions.insert(Permissions.userWrite)
      }
    }
    return permissions
  }
  
  required init?(map: Map) { super.init() }
  
  func mapping(map: Map) {
    self.scope <- map["scope"]
    self.secret <- map["access_token"]
    self.type <- map["token_type"]
  }
  
}

