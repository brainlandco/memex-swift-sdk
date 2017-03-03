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
  
  public func updateSubscriptionReceipt(receiptData: NSData,
                                        transactionID: String?,
                                        completion: @escaping VoidOutputs) {
    let base64 = receiptData.base64EncodedString(options: [.encodingEndLineWithLineFeed])
    POST("users/self/update-subscription",
         parameters: ["receipt_data": base64]) { response in
          completion(response.error)
    }
  }
  
}
