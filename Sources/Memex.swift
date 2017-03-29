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
  
  public init(key: String, secret: String, environment: Environment = .production, verbose: Bool = false) {
    let configuration = Sushi.Configuration(serverURL: Memex.serverURL(forEnvironment: environment),
                                            clientCredentials: Credentials(identifier: key, secret: secret),
                                            logAllRequests: verbose,
                                            authTokenKey: Memex.authToken(forEnvironment: environment),
                                            authFirstLaunchKey: "firstLaunch")
    super.init(configuration: configuration)
  }
  
  private static func serverURL(forEnvironment environment: Environment) -> URL {
    switch environment{
    case .production:
      return URL(string: "https://www.memex.co/api/v1")!
    case .staging:
      return URL(string: "https://memexapp-stage.herokuapp.com/api/v1")!
    case .localhost:
      return URL(string: "http://localhost:5000")!
    case .sandbox:
      return URL(string: "https://memexapp-sandbox.herokuapp.com/api/v1")!  //not yet implemented
    }
  }
  
  private static func authToken(forEnvironment environment: Environment) -> String {
    switch environment{
    case .production:
      return "SUAuthorizationController.token"
    case .staging:
      return "SUAuthorizationController.token.dev"
    case .localhost:
      return "SUAuthorizationController.token.dev"
    case .sandbox:
      return "SUAuthorizationController.token.dev"
    }
  }
  
}
