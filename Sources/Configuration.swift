
import Foundation

public class Configuration {
  
  let serverURL: URL
  let appToken: String!
  let logAllRequests: Bool
  let authTokenKey: String!
  let authFirstLaunchKey: String!
  
  public init(serverURL: URL,
              appToken: String,
              logAllRequests: Bool,
              authTokenKey: String,
              authFirstLaunchKey: String) {
    self.serverURL = serverURL
    self.appToken = appToken
    self.logAllRequests = logAllRequests
    self.authTokenKey = authTokenKey
    self.authFirstLaunchKey = authFirstLaunchKey
  }
  
}
