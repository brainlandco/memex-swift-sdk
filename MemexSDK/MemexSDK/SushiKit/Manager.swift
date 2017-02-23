//
//  Configuration.swift
//  MemexSDK
//
//  Created by Adam Zdara on 23/02/2017.
//  Copyright © 2017 Memex Inc. All rights reserved.
//

import Foundation
import ReachabilitySwift

public class Manager {
  
  // MARK: Data
  
  public static var sharedModule: SUModule!
  public let configuration: Configuration
  var authorizationController: AuthorizationController!
  var requestInvoker: RequestInvoker!
  let defaultQueryStringTransformer: QueryStringTransformerProtocol
  var healthChecker: ServiceHealthChecker!

  // MARK: Executables
  
  public init(configuration: Configuration) {
    self.configuration = configuration
    
    self.defaultQueryStringTransformer = StandardQueryStringTransformer()
    super.init()
    
    self.authorizationController = AuthorizationController(module: self)
    self.requestInvoker = RequestInvoker(module: self)
  }
  
}


