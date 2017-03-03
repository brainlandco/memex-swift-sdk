//
//  Memex.swift
//  MemexSDK
//
//  Created by Adam Zdara on 03/03/2017.
//  Copyright © 2017 MemexApp. All rights reserved.
//

import Foundation
import Sushi

public class Memex: Sushi.Service {
  
  init(key: String) {
    let configuration = Sushi.Configuration(serverURL: URL(string: "localhost:8080"),
                                            userAgent: nil,
                                            clientCredentials: nil,
                                            logAllRequests: false,
                                            authTokenKey: "authToken",
                                            authFirstLaunchKey: "firstLaunch")
    super.init(configuration: configuration)
  }
}
