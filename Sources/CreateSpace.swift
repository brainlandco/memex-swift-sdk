//
//  RMCreateSpaceOperation.swift
//  Memex
//
//  Created by Adam Zdara on 21/02/2017.
//  Copyright © 2017 Adam Zdara. All rights reserved.
//

import Foundation
import Sushi
import ObjectMapper

public extension Memex {
  
  public func createSpace(space: Space,
                          process: Bool,
                          autodump: Bool,
                          completion: @escaping (_ spaceMUID: String?, _ error: Swift.Error?)->()) {
    var spaceJSON = space.toJSON()
    spaceJSON["representations"] = space.representations.flatMap { media in
      media.toJSON()
    }
    let parameters: [String: Any] = ["space": spaceJSON,
                                     "process": process,
                                     "autodump": autodump]
    POST("spaces", parameters: parameters ) { response in
      let space = response.contentDictionary?["space"] as? [String: Any]
      completion(space?["muid"] as? String, response.error)
    }
  }
  
}
