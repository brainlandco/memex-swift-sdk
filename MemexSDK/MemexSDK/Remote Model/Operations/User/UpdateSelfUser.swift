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

public struct RMUpdateUser {
  
  public class Parameters: OPVoidOperationParameters {
    var user: RMUser!
  }
  
  public class Operation: RMOperation<Parameters, OPVoidOperationResults> {
    
    init(module: OPModuleProtocol? = nil) { super.init(module: module) }
    
    public func withParameters(user user: RMUser) -> Self {
      self.parameters.user = user
      return self
    }
    
    override public func defineValidationRules() {
      requireNonNil(self.parameters.user, "Missing user")
    }
    
    override public func execute() {
      var userParams = SUMapper<RMUser>().toJSON(self.parameters.user)
      userParams["avatar"] = nil
      if let avatar_muid = self.parameters.user.avatar?.MUID {
        userParams["avatar_muid"] = avatar_muid
      }
      POST("users/self",
           parameters: ["user": userParams])
    }
  }
}
