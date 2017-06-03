import Foundation

/// Notification that is sent when user log in/out. This object is wrapped in NSNotification in object property.
public class AuthorizationStatusChangedEvent: Event {
  
  public struct Constants {
    /// This key represents NSNotification name
    public static let notificationName = "AuthorizationStatusChangedEvent"
  }
  
  /// User authentication token
  public let userToken: String?
  
  init(userToken: String?) {
    self.userToken = userToken
    super.init(name: Constants.notificationName)
  }
  
}
