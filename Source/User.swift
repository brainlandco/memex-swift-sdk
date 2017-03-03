// ******************************************************************************
//
// Copyright © 2015, Adam Zdara. All rights reserved.
// Author: Adam Zdara
//
// All rights reserved. This source code can be used only for purposes specified
// by the given license contract signed by the rightful deputy of Adam Zdara.
// This source code can be used only by the owner of the license.
//
// Any disputes arising in respect of this agreement (license) shall be brought
// before the Municipal Court of Prague.
//
// ******************************************************************************

import Foundation

public class User: Entity {
  
  // MARK: Properties

  public var ID: Int?
  public var fullname: String?
  public var email: String?
  public var hasPassword: Bool?
  public var advanced: Bool?
  public var avatar: Media?
  public var originSpaceMUID: String?
  public var authorizationToken: String?
  public var createdAt: NSDate?
  public var updatedAt: NSDate?
  public var subscriptionExpiresAt: NSDate?
  public var usedBytesCount: Int64 = 0
  public var availableBytesCount: Int64 = 0
  public var extraReceivedBytesCount: Int64 = 0
  public var extraAvailableBytesCount: Int64 = 0
  public var extraStorageResetsAt: NSDate?
  public var reedemCode: String?
  public var reedemShareURL: NSURL?
  public override var hashValue: Int {
    return self.ID!.hashValue
  }
  
  // MARK: Lifecycle
  
  public required init() {
    super.init()
  }
  
  public required init?(_ map: Map) {
    super.init(map)
  }
  
  // MARK: Mapping
  
  override public func mapping(map: Map) {
    self.ID <-> map["id"]
    self.createdAt <-> map["created_at"]
    self.updatedAt <-> map["updated_at"]
    self.fullname <-> map["fullname"]
    self.email <-> map["email"]
    self.hasPassword <-> map["has_password"]
    self.authorizationToken <-> map["icloud_token"]
    self.avatar <-> map["avatar"]
    self.subscriptionExpiresAt <-> map["subscription_expires_at"]
    self.usedBytesCount <-> (map["used_bytes_count"], SUBytesCountTransform())
    self.availableBytesCount <-> (map["available_bytes_count"], SUBytesCountTransform())
    self.extraReceivedBytesCount <-> (map["extra_received_bytes_count"], SUBytesCountTransform())
    self.extraAvailableBytesCount <-> (map["extra_available_bytes_count"], SUBytesCountTransform())
    self.extraStorageResetsAt <-> map["extra_storage_resets_at"]
    self.reedemCode <-> map["reedem_code"]
    self.reedemShareURL <-> map["reedem_share_url"]
    self.advanced <-> map["advanced"]
  }
   
}

public func ==(lhs: User, rhs: User) -> Bool {
  if lhs.ID == nil || rhs.ID == nil {
    return lhs === rhs
  }
  return lhs.ID == rhs.ID
}
