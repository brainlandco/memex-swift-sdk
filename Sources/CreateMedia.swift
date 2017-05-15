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

public extension Spaces {
  
  public func createMedia(media: Media,
                          completion: @escaping (_ media: Media?, _ error: Swift.Error?)->()) {
    POST("media",
         parameters: [
          "media": Mapper<Media>().toJSON(media)
    ]) { [weak self] response in
      completion(self?.entityFromDictionary(dictionary: response.dataDictionary?["media"]),
                 response.error)
    }
  }
}
