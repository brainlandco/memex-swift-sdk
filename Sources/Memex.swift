//
//  Memex.swift
//  MemexSDK
//
//  Created by Adam Zdara on 03/03/2017.
//  Copyright © 2017 MemexApp. All rights reserved.
//

import Foundation
import Sushi
import Atom

public class Memex: Sushi.Service {
  
  public init(key: String, secret: String, environment: Environment = .production) {
    let configuration = Sushi.Configuration(serverURL: Memex.serverURL(forEnvironment: environment),
                                            clientCredentials: Credentials(identifier: key, secret: secret),
                                            logAllRequests: false,
                                            authTokenKey: "authToken",
                                            authFirstLaunchKey: "firstLaunch")
    super.init(configuration: configuration)
  }
  
  private static func serverURL(forEnvironment environment: Environment) -> URL {
    switch environment{
    case .production:
      return URL(string: "memex.co/api")!
    case .staging:
      return URL(string: "memexapp-staging.herokuapp.com/api")!
    case .localhost:
      return URL(string: "localhost:5000")!
    case .sandbox:
      return URL(string: "memexapp-sandbox.herokuapp.com/api")!  //not yet implemented
    }
  }
  
}
