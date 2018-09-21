//
//  MFA.swift
//  KeychainSwift
//
//  Created by Adam Zdara on 30/10/2017.
//

import Foundation
import ObjectMapper

/// multi-factor auth type
public enum MFAType: String {
  /// Email Address
  case email = "email"
  /// Phone NUmber
  case phone = "phone"
}

/// Object that represents MFA challange
public class MFAChallange: JSONRepresentable {
  
  /// Retry token
  public var retryToken: String?
  /// Type of challange
  public var type: MFAType?
  /// Last update timestamp
  public var expiresAt: Date?
  
  public override var hash: Int {
    return self.retryToken!.hashValue
  }
  
  public required init() {
    super.init()
  }
  
  public required init?(map: Map) {
    super.init(map: map)
  }
  
  override public func mapping(map: Map) {
    self.retryToken <- map["retry_token"]
    self.type <- map["type"]
    self.expiresAt <- map["activation_token_expires_at"]
  }
  
}
