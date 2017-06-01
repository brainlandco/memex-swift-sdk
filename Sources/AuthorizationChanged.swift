import Foundation

public class AuthorizationStatusChangedEvent: Event {
  
  public struct Constants {
    public static let key = "AuthorizationStatusChangedEvent"
  }
  
  public let userToken: String?
  
  init(userToken: String?) {
    self.userToken = userToken
    super.init(name: Constants.key)
  }
  
}
