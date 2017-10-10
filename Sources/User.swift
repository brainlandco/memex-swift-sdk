
import Foundation
import ObjectMapper

/// Object that represents Memex user
public class User: JSONRepresentable {
  
  public struct Constants {
    /// This constant should be used instead of userID always when you want tel SDK when you want you own user object.
    public static let myselfUserID = -1
  }
  
  /// Unique user ID
  public var ID: Int?
  /// Timestamp when was user create
  public var createdAt: Date?
  /// Timestamp when was user object modified
  public var updatedAt: Date?
  /// User full name in format (FirstName LastName)
  public var fullname: String?
  /// User email
  public var email: String?
  /// Email Verification Flag
  public var isEmailVerified: Bool?
  /// User full name in format (FirstName LastName)
  public var password: String?
  /// Date of last password change
  public var passwordChangedAt: Date?
  /// Avatar of user.
  public var avatar: Media?
  /// MUID of users origin space (root, entry point)
  public var originSpaceMUID: String?
  /// Two Factor Authorization Flag
  public var isTFAEnabled: Bool?
  /// Flag that tells if user set his password or he can be only authenticated using onboarding token
  public var hasPassword: Bool?
  /// Flag that tells if user has enabled advanced features. This will be in future replaced with full feature flags set.
  public var advanced: Bool?
  public override var hashValue: Int {
    return self.ID!.hashValue
  }
  
  public required init() {
    super.init()
  }
  
  public required init?(map: Map) {
    super.init(map: map)
  }
  
  override public func mapping(map: Map) {
    self.ID <- map["id"]
    self.createdAt <- map["created_at"]
    self.updatedAt <- map["updated_at"]
    self.fullname <- map["fullname"]
    self.email <- map["email"]
    self.password <- map["password"]
    self.avatar <- map["avatar"]
    self.originSpaceMUID <- map["origin_space_muid"]
    self.hasPassword <- map["has_password"]
    self.isEmailVerified <- map["is_email_verified"]
    self.passwordChangedAt <- map["password_cahnged_at"]
  }
   
}

public func ==(lhs: User, rhs: User) -> Bool {
  if lhs.ID == nil || rhs.ID == nil {
    return lhs === rhs
  }
  return lhs.ID == rhs.ID
}
