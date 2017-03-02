// ******************************************************************************
//
// Copyright © 2015, Adam Zdara. All rights reserved.
//
// All rights reserved. This source code can be used only for purposes specified
// by the given license contract signed by the rightful deputy of Adam Zdara.
// This source code can be used only by the owner of the license.
//
// Any disputes arising in respect of this agreement (license) shall be brought
// before the Municipal Court of Prague.
//
// ******************************************************************************

public class RMOperation<P: OPOperationParameters, R: OPOperationResults>: SUOperation<P, R> {

  var module: RMModule {
    return self.operationModule! as! RMModule
  }
  
  public override init(module: OPModuleProtocol!, file: StaticString = #file) {
    super.init(module: module, file: file)
  }

}