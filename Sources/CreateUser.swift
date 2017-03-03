// ******************************************************************************
//
// Copyright © 2015, Adam Zdara. All rights reserved.
// Author: Adam Zdara
//
// All rights reserved. This source code can be used only for purposes specified
// by the given license contract signed by the rightful deputy of Adam Zdara.
// This source code can be used only by the owner of the license.
//
// Any disputes arising in respect of this agreement (license) shall be brought
// before the Municipal Court of Prague.
//
// ******************************************************************************

import Foundation
import Sushi
import ObjectMapper

public extension Memex {
  
  public func createUser(user: User,
                         inviteToken: String?,
                         completion: @escaping VoidOutputs) {
    var parameters = [String: Any]()
    parameters["user"] = user.toJSON()
    if let token = inviteToken {
      parameters["invite_token"] = token
    }
    POST("users", parameters: parameters) { response in
      completion(response.error)
    }
  }
}
