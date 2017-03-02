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

public struct SUAuthorize {
  
  public enum AuthorizationMethod {
    case UserCredentials
    case UUID
  }
  
  public class Inputs: OPVoidOperationParameters {
    public var method: AuthorizationMethod = .UserCredentials
    public var credentials: ATCredentials! // when authorizing with UUID sed credentils.identifier to UUID
  }
  
  public class Operation: SUOperation<Inputs, OPVoidOperationResults> {
    
    public init(credentials: ATCredentials,
                method: AuthorizationMethod = .UserCredentials,
                module: OPModuleProtocol? = nil) {
      super.init(module: module)
      self.parameters.credentials = credentials
      self.parameters.method = method
    }
    
    override public func execute() {
      let completion = { (token: SUToken?, error: ErrorType?) -> Void in
        if error == nil {
          self.succeed()
        } else {
          self.failWithErrors([error!])
        }
      }
      let credentials = self.parameters.credentials
      switch self.parameters.method {
      case .UserCredentials:
        self.sushiModule.authorizationController.authorizeForUserScopeTokenWithCredentials(credentials,
                                                                                           completionHandler: completion)
      case .UUID:
        self.sushiModule.authorizationController.authorizeForUserScopeTokenWithUUID(credentials.identifier,
                                                                                    completionHandler: completion)
      }
    }
  }
}

