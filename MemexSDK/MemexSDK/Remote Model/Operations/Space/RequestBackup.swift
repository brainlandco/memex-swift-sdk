/**
 *
 * Copyright (c) 2016, Adam Zdara.
 * Created by: Adam Zdara on 09/06/16
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

public struct RMRequestBackup {
  
  public class Operation: RMOperation<OPVoidOperationParameters, OPVoidOperationResults> {
    
    public init(module: OPModuleProtocol? = nil) {
      super.init(module: module)
    }
    
    override public func execute() {
      GET("users/self/backup")
    }
    
  }
}



