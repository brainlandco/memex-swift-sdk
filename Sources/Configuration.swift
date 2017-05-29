
import Foundation

public class Configuration {
  
  let serverURL: URL
  let appToken: String
  let logAllRequests: Bool
  let userTokenKey: String
  let allowDeauthorization: Bool
  
  public init(serverURL: URL,
              appToken: String,
              logAllRequests: Bool,
              userTokenKey: String,
              allowDeauthorization: Bool) {
    self.serverURL = serverURL
    self.appToken = appToken
    self.logAllRequests = logAllRequests
    self.userTokenKey = userTokenKey
    self.allowDeauthorization = allowDeauthorization
  }
  
}
