
import Foundation

public typealias Memex = Spaces

public class Spaces {
  
  // MARK: Data
  
  public let configuration: Configuration
  var auth: AuthorizationController!
  var requestor: RequestInvoker!
  let queryStringTransformer: QueryStringTransformer
  var healthChecker: HealthChecker!
  
  // MARK: Executables

  public init(appToken: String,
              environment: Environment = .production,
              verbose: Bool = false,
              userTokenKey: String? = nil,
              allowDeauthorization: Bool = true) {
    self.configuration = Configuration(serverURL: Spaces.serverURL(forEnvironment: environment),
                                      appToken: appToken,
                                      logAllRequests: verbose,
                                      userTokenKey: userTokenKey != nil ? userTokenKey! : Spaces.authToken(forEnvironment: environment),
                                      allowDeauthorization: allowDeauthorization)
    
    self.queryStringTransformer = QueryStringTransformer()
    
    self.auth = AuthorizationController(spaces: self)
    self.requestor = RequestInvoker(spaces: self)
  }
  
  func emit(event: Event) {
    let notification = Notification(name: Notification.Name(rawValue: event.name),
                                    object: event,
                                    userInfo: nil)
    NotificationCenter.default.post(notification)
  }
  
  private static func serverURL(forEnvironment environment: Environment) -> URL {
    switch environment{
    case .production:
      return URL(string: "https://mmx-spaces-api-prod.herokuapp.com")!
    case .staging:
      return URL(string: "https://mmx-spaces-api-stage.herokuapp.com")!
    case .local:
      return URL(string: "http://10.0.0.38:5000")!
    }
  }
  
  private static func authToken(forEnvironment environment: Environment) -> String {
    switch environment{
    case .production:
      return "userToken.prod"
    case .staging:
      return "userToken.stage"
    case .local:
      return "userToken.local"
    }
  }
  
}
