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

public extension Memex {
  
  public class Parameters: OPVoidOperationParameters {
    var email: String!
  }
  
  public class Operation: RMOperation<Parameters, OPVoidOperationResults> {
    
    init(module: OPModuleProtocol? = nil) { super.init(module: module) }
    
    public func withParameters(email email: String) -> Self {
      self.parameters.email = email
      return self
    }
    
    override public func defineValidationRules() {
      requireNonNil(self.parameters.email, "Missing email")
    }
    
    override public func execute() {
      POST("invitations",
           parameters: ["email": self.parameters.email])
    }
  }
}
