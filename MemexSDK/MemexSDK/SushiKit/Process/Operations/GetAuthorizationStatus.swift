/**
 *
 * Copyright (c) 2015, Adam Zdara.
 * Created by: Adam Zdara on 16.12.2015
 *
 * All rights reserved. This source code can be used only for purposes specified
 * by the given license contract signed by the rightful deputy of Adam Zdara.
 * This source code can be used only by the owner of the license.
 *
 * Any disputes arising in respect of this agreement (license) shall be brought
 * before the Municipal Court of Prague.
 *
 */

public struct SUGetAuthorizationStatus {
  
  public class Outputs: OPVoidOperationResults {
    public var status: SUAuthorizationStatus!
  }
  
  public class Operation: SUOperation<OPVoidOperationParameters, Outputs> {
    
    public init(module: OPModuleProtocol? = nil) { super.init(module: module) }
    
    override public func execute() {
      self.results.status = self.sushiModule.authorizationController.externalAuthorizationStatus(lock: true)
      self.succeed()
    }
  }
  
}
