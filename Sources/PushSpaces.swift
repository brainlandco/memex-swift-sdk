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

public extension Memex {
  
  public class Inputs: OPVoidOperationParameters {
    public var items: [RMSpace]!
  }

  public class Outputs: OPVoidOperationResults {
    public var oldModelVersion: Int!
    public var modelVersion: Int!
  }
  
  public class Operation: RMOperation<Inputs, Outputs> {
    
    public init(items: [RMSpace]?,
                module: OPModuleProtocol? = nil) {
      super.init(module: module)
      self.parameters.items = items
    }
    
    override public func execute() {
      POST("spaces/batched",
           parameters:["data": self.parameters.items.toJSON()]) { [weak self] response in
            self?.results.oldModelVersion = response.metadata?["old_model_version"] as? Int
            self?.results.modelVersion = response.metadata?["model_version"] as? Int
      }

    }
  }
  
}



