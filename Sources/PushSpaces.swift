/**
 *
 * Copyright (c) 2016, Adam Zdara.
 * Created by: Adam Zdara on 12/06/16
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
import ObjectMapper

public typealias PushOutputs = (
  _ oldModelVersion: Int?,
  _ modelVersion: Int?,
  _ error: Swift.Error?)->()

public extension Spaces {
  
  public func pushSpaces(items: [Space],
                         completion: @escaping PushOutputs) {
    POST("spaces/batched",
         parameters:["data": items.toJSON()]) { response in
          let oldModelVersion = response.metadata?["old_model_version"] as? Int
          let modelVersion = response.metadata?["model_version"] as? Int
          completion(oldModelVersion, modelVersion, response.error)
    }
  }
  
}



