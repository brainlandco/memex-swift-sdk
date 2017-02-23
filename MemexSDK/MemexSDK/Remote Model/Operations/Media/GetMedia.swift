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

public struct RMGetMedia {
  
  public class Inputs: OPVoidOperationParameters {
    public var media: RMMedia!
  }
  
  public class Outputs: OPVoidOperationResults {
    public var media: RMMedia!
  }
  
  public class Operation: RMOperation<Inputs, Outputs> {
    
    init(module: OPModuleProtocol? = nil) {
      super.init(module: module)
    }
    
    public func withParameters(media media: RMMedia) -> Self {
      self.parameters.media = media
      return self
    }
    
    override public func defineValidationRules() {
      requireNonNil(self.parameters.media, "Missing media")
    }
    
    override public func execute() {
      GET("media/\(self.parameters.media.MUID!)") { [weak self] response in
        self?.results.media = self?.entityFromDictionary(response.data!["media"])
      }
    }
    
  }
}
