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

import Foundation
import Sushi
import ObjectMapper

typealias Outputs = (
  _ items: [Link]?,
  _ modelVersion: Int?,
  _ totalItems: Int?,
  _ hasMore: Bool?,
  _ nextOffset: Int?,
  _ error: Error?)->()

public extension Memex {
  
  public func pullLinks(lastModelVersion: Int?,
                        offset: Int?,
                        completion: @escaping Outputs) {
    var parameters = [String: Any]()
    if let value = lastModelVersion {
      parameters["last_model_version"] = value
    }
    if let value = offset {
      parameters["offset"] = value
    }
    GET("users/self/links",
        parameters: parameters) { [weak self] response in
          self?.results.items = self?.entitiesFromArray(response.data)
          self?.results.modelVersion = response.metadata?["model_version"] as? Int
          self?.results.totalItems = response.metadata?["total"] as? Int
          self?.results.hasMore = response.metadata?["has_more"] as? Bool
          self?.results.nextOffset = response.metadata?["next_offset"] as? Int
    }
  }

}



