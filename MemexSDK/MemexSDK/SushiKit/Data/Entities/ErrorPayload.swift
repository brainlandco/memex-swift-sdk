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
import UIKit

class ErrorPayload: NSObject, Mappable {
  
  var code: Int?
  var message: String?
  
  init(code: Int, message: String) {
    self.code = code
    self.message = message
  }
  
  required init?(_ map: Map) { super.init() }
  
  func mapping(map: SUMap) {
    self.code <-> map["code"]
    self.message <-> map["message"]
  }
  
}
