
import Foundation

public class AuthorizationStatusChangedEvent: Event {
  
  let token: String?
  
  init(token: String?) {
    self.token = token
    super.init(name: "AuthorizationStatusChangedEvent")
  }
  
}
