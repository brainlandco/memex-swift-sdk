
import Foundation

open class Service {
  
  // MARK: Data
  
  public let configuration: Configuration
  var auth: AuthorizationController!
  var requestor: RequestInvoker!
  let queryStringTransformer: QueryStringTransformer
  var healthChecker: HealthChecker!

  // MARK: Executables
  
  public init(configuration: Configuration) {
    self.configuration = configuration
    
    self.queryStringTransformer = QueryStringTransformer()
    
    self.auth = AuthorizationController(service: self)
    self.requestor = RequestInvoker(service: self)
  }
  
  func emit(event: Event) {
    let notification = Notification(name: Notification.Name(rawValue: event.name),
                                    object: event,
                                    userInfo: nil)
    NotificationCenter.default.post(notification)
  }
  
}


