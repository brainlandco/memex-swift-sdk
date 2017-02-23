//
//  Configuration.swift
//  MemexSDK
//
//  Created by Adam Zdara on 23/02/2017.
//  Copyright © 2017 Memex Inc. All rights reserved.
//

import Foundation

public class Configuration {
  
  public var serverURL: NSURL! = nil
  public var userAgent: String? = nil
  public var clientCredentials: ATCredentials! = nil
  public var logAllRequests: Bool = false
  
  public init(serverURL: NSURL? = nil,
              userAgent: String? = nil,
              clientCredentials: ATCredentials? = nil,
              logAllRequests: Bool = false) {
    self.serverURL = serverURL
    self.userAgent = userAgent
    self.clientCredentials = clientCredentials
    self.logAllRequests = logAllRequests
  }
  
}
