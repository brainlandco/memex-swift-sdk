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

public struct RMCreateUser {
  
  public class Parameters: OPVoidOperationParameters {
    var user: RMUser!
    var inviteToken: String?
  }
  
  public class Operation: RMOperation<Parameters, OPVoidOperationResults> {
    
    init(user: RMUser,
         inviteToken: String?,
         module: OPModuleProtocol? = nil) {
      super.init(module: module)
      self.parameters.user = user
      self.parameters.inviteToken = inviteToken
    }
    
    override public func execute() {
      var parameters = [String: AnyObject]()
      parameters["user"] = SUMapper<RMUser>().toJSON(self.parameters.user)
      if let token = self.parameters.inviteToken {
        parameters["invite_token"] = token
      }
      POST("users", parameters: parameters)
    }
  }
}
