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
  
  public func getUser(userID: Int?,
                      completion: @escaping (_ user: User?, _ error: Swift.Error?)->()) {
    let id = userID == User.Constants.myselfUserID ? "self" : "\(userID)"
    GET("users/\(id)",
    parameters: nil) { [weak self] response in
      completion(self?.entityFromDictionary(dictionary: response.dataDictionary?["user"]), response.error)
    }
  }
}
