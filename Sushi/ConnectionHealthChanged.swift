
import Foundation

public class ConnectionHealthChangedEvent: Event {
  
  public let offline: Bool
  public let maintanance: Bool
  
  init(offline: Bool, maintanance: Bool) {
    self.offline = offline
    self.maintanance = maintanance
    super.init(name: "ConnectionHealthChangedEvent")
  }
  
}
