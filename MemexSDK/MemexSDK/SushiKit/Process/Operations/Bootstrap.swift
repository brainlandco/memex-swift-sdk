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

public struct SUBootstrap {
  
  public class Inputs: OPVoidOperationParameters {
    public var allowDeauthorization: Bool = true
  }
  
  public class Operation: SUOperation<Inputs, OPVoidOperationResults> {
    
    public init(allowDeauthorization: Bool, module: OPModuleProtocol? = nil) {
      super.init(module: module)
      self.parameters.allowDeauthorization = allowDeauthorization
    }
    
    override public func execute() {
      if self.sushiModule.healthChecker == nil {
        self.sushiModule.healthChecker = SUServiceHealthChecker(URL: self.sushiModule.configuration.serverURL,
                                                    didChangeState: { offline, maintanance in
                                                      SUConnectionHealthChangedEvent(offline: offline, maintanance: maintanance)
                                                        .publishOn(self.sushiModule.eventQueue)
        })
      } else {
        self.sushiModule.healthChecker.startMaintananceObserver(restart: true)
      }
      self.sushiModule.authorizationController.bootstrap(allowDeauthorization: self.parameters.allowDeauthorization) {
        self.succeed()
      }
    }
    
  }
}

