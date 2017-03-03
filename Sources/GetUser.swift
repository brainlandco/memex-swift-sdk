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
    public var userID: Int!
  }
  
  public class Results: OPVoidOperationResults {
    public var user: RMUser!
  }
  
  public class Operation: RMOperation<Parameters, Results> {
    
    init(module: OPModuleProtocol? = nil) { super.init(module: module) }
    
    public func withParameters(userID userID: Int?) -> Self {
      self.parameters.userID = userID
      return self
    }
    
    override public func defineValidationRules() {
      requireNonNil(self.parameters.userID, "Missing userID")
    }
    
    override public func execute() {
      let id = self.parameters.userID == RMUser.Constants.SELF_ID ? "self" : "\(self.parameters.userID)"
      GET("users/\(id)",
          parameters: nil) { [weak self] response in
            self?.results.user = self?.entityFromDictionary(response.data?["user"])
      }
    }
  }
}
