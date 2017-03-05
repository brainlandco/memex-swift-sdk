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

typealias Outputs = (
  _ oldModelVersion: Int?,
  _ modelVersion: Int?,
  _ error: Error?)->()

public extension Memex {
  
  public func pushMedia(items: [Media]?,
                        completion: @escaping Outputs) {
    POST("media/batched",
         parameters:["data": items.toJSON()]) { [weak self] response in
          self?.results.oldModelVersion = response.metadata?["old_model_version"] as? Int
          self?.results.modelVersion = response.metadata?["model_version"] as? Int
    }
  }
  
}



