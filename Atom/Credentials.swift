
import Foundation

public class Credentials {
  
  public var identifier: String! = nil
  public var secret: String! = nil
  
  public init(identifier: String? = nil, secret: String? = nil) {
    self.identifier = identifier
    self.secret = secret
  }
  
}
