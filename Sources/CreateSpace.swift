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

typealias Outputs = (_ spaceMUID: String?, _ error: Error?)->()

public extension Memex {
  
  public func createSpace(space: Space,
                          process: Bool,
                          autodump: Bool,
                          completion: @escaping Outputs) {
    var spaceJSON = space.toJSON()
    spaceJSON["representations"] = space.representations.flatMap { media in
      media.toJSON()
    }
    let parameters: [String : AnyObject] = ["space": spaceJSON,
                                            "process": process,
                                            "autodump": autodump]
    POST("spaces", parameters: parameters ) { [weak self] response in
      let space = response.content!["space"] as! [String: AnyObject]
      self?.results.spaceMUID = space["muid"] as! String
    }
  }

}
