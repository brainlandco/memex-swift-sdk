//
//  RMCreateSpaceOperation.swift
//  Memex
//
//  Created by Adam Zdara on 21/02/2017.
//  Copyright © 2017 Adam Zdara. All rights reserved.
//

import Foundation

import Foundation
import Sushi
import ObjectMapper

public extension Memex {
  
  public class Inputs: OPVoidOperationParameters {
    public var space: RMSpace!
    public var process: Bool!
    public var autodump: Bool!
  }
  
  public class Outputs: OPVoidOperationResults {
    public var spaceMUID: String!
  }
  
  public class Operation: RMOperation<Inputs, Outputs> {
    init(space: RMSpace,
         process: Bool,
         autodump: Bool,
         module: OPModuleProtocol? = nil) {
      super.init(module: module)
      self.parameters.space = space
      self.parameters.process = process
      self.parameters.autodump = autodump
    }
    
    override public func execute() {
      var spaceJSON = self.parameters.space.toJSON()
      spaceJSON["representations"] = self.parameters.space.representations.flatMap { media in
        media.toJSON()
      }
      let parameters: [String : AnyObject] = ["space": spaceJSON,
                                              "process": self.parameters.process,
                                              "autodump": self.parameters.autodump]
      POST("spaces", parameters: parameters ) { [weak self] response in
        let space = response.content!["space"] as! [String: AnyObject]
        self?.results.spaceMUID = space["muid"] as! String
      }
    }
  }
  
}
