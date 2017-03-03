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
  
  public class Parameters: OPVoidOperationParameters
  {
    var oldPassword: String?
    var newPassword: String!
  }
  public class Operation: RMOperation<Parameters, OPVoidOperationResults>
  {
    init(module: OPModuleProtocol? = nil) { super.init(module: module) }
    
    public func withParameters(oldPassword oldPassword: String?, newPassword: String) -> Self
    {
      self.parameters.oldPassword = oldPassword
      self.parameters.newPassword = newPassword
      return self
    }
    
    override public func defineValidationRules()
    {
      requireNonNil(self.parameters.newPassword, "Missing newPassword")
    }
    
    override public func execute()
    {
      var parameters = [String: AnyObject]()
      if let oldPassword = self.parameters.oldPassword {
        parameters["old_password"] = oldPassword
      }
      parameters["new_password"] = self.parameters.newPassword
      POST("users/self/change-password",
        parameters: parameters)
    }
  }
}
