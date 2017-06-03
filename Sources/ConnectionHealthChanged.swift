
import Foundation

/// SDK provides service accessibility notification system so when service goes to/out of maintanance or offline this notification is triggered
public class ConnectionHealthChangedEvent: Event {
  
  public struct Constants {
    /// This key represents NSNotification name
    public static let notificationName = "ConnectionHealthChangedEvent"
  }
  
  /// Flag that says if memex service is accessible
  public let offline: Bool
  /// Flag that says if memex service is under maintanance
  public let maintanance: Bool
  
  init(offline: Bool, maintanance: Bool) {
    self.offline = offline
    self.maintanance = maintanance
    super.init(name: Constants.notificationName)
  }
  
}
