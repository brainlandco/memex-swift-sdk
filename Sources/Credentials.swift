
import Foundation

/// Object that wraps user credentials
public class Credentials {
  
  /// User email or username
  public var identifier: String! = nil
  /// User's password
  public var secret: String! = nil
  
  public init(identifier: String? = nil, secret: String? = nil) {
    self.identifier = identifier
    self.secret = secret
  }
  
}
