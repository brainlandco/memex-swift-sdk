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

public struct RMUpdateSubscriptionReceipt {
  
  public class Parameters: OPVoidOperationParameters {
    var receiptData: NSData!
    var transactionID: String?
  }
  
  public class Operation: RMOperation<Parameters, OPVoidOperationResults> {
    
    init(module: OPModuleProtocol? = nil) { super.init(module: module) }
    
    public func withParameters(receiptData receiptData: NSData, transactionID: String?) -> Self {
      self.parameters.receiptData = receiptData
      self.parameters.transactionID = transactionID
      return self
    }
    
    override public func defineValidationRules() {
      requireNonNil(self.parameters.receiptData, "Missing receiptData")
    }
    
    override public func execute() {
      let base64 = self.parameters.receiptData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithLineFeed)
      POST("users/self/update-subscription",
           parameters: ["receipt_data": base64])
    }
  }
}
