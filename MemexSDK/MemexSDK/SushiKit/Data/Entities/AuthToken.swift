/**
 *
 * Copyright (c) 2015, Adam Zdara.
 * Created by: Adam Zdara on 16.12.2015
 *
 * All rights reserved. This source code can be used only for purposes specified
 * by the given license contract signed by the rightful deputy of Adam Zdara.
 * This source code can be used only by the owner of the license.
 *
 * Any disputes arising in respect of this agreement (license) shall be brought
 * before the Municipal Court of Prague.
 *
 */

import Foundation

class AuthToken: NSObject, Mappable {
  
  var secret: String?
  var type: String?
  var scope: String?
  var permissions: Permissions {
    var permissions = Permissions.None
    let castedScope = self.scope! as NSString
    let array = castedScope.componentsSeparatedByString(" ")
    for value in array {
      if value == "public" {
        permissions.insert(Permissions.Public)
      } else if value == "user_read" {
        permissions.insert(Permissions.UserRead)
      } else if value == "user_write" {
        permissions.insert(Permissions.UserWrite)
      }
    }
    return permissions
  }
  
  required init?(_ map: Map) { super.init() }
  
  func mapping(map: Map) {
    self.scope <-> map["scope"]
    self.secret <-> map["access_token"]
    self.type <-> map["token_type"]
  }
  
}

