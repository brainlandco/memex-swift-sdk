
import Foundation
import Atom

public class Configuration {
  
  let serverURL: URL
  let appToken: String!
  let logAllRequests: Bool
  let authTokenKey: String!
  let authFirstLaunchKey: String!
  
  public init(serverURL: URL,
              appToken: String,
              logAllRequests: Bool = false,
              authTokenKey: String = "SUAuthorizationController.token",
              authFirstLaunchKey: String = "TPRMAuthorizationManagerFirstLaunch") {
    self.serverURL = serverURL
    self.appToken = appToken
    self.logAllRequests = logAllRequests
    self.authTokenKey = authTokenKey
    self.authFirstLaunchKey = authFirstLaunchKey
  }
  
}
