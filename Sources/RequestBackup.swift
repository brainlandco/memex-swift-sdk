/**
 *
 * Copyright (c) 2016, Adam Zdara.
 * Created by: Adam Zdara on 09/06/16
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
import Sushi

public extension Memex {
  
  public func requestBackup(completion: @escaping VoidOutputs) {
    GET("users/self/backup") { response in
      completion(response.error)
    }
  }
  
}



