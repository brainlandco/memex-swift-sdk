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

import Foundation
import Sushi
import ObjectMapper

public extension Memex {
  
  public class Parameters: OPVoidOperationParameters {
    public var MUID: String!
  }
  
  public class Operation: RMOperation<Parameters, OPVoidOperationResults> {
    init(MUID: String,
         module: OPModuleProtocol? = nil) {
      super.init(module: module)
      self.parameters.MUID = MUID
    }

    override public func execute() {
      POST("spaces/\(self.parameters.MUID)/process")
    }
  }
  
}
