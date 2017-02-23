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

public class RMLink: SUEntity, RMObjectProtocol {
  
  public var MUID: String?
  public override var hashValue: Int {
    return self.MUID!.hashValue
  }
  public var createdAt: NSDate?
  public var updatedAt: NSDate?
  public var state: RMObjectState?
  public var ownerID: Int?
  public var createdBy: RMManagementEntity?
  public var managedBy: RMManagementEntity?
  public var managedAt: NSDate?
  public var singleSystemManagementRequired: Bool?
  public var clientIdentifier: String?
  public var order: Int?
  public var tagLabel: String?
  public var preview: Bool?
  public var originSpaceMUID: String?
  public var targetSpaceMUID: String?
  
  public required init() { super.init() }
  
  public required init?(_ map: SUMap) { super.init(map) }

  override public func mapping(map: SUMap) {
    self.MUID <-> map["muid"]
    self.createdAt <-> map["created_at"]
    self.updatedAt <-> map["updated_at"]
    self.state <-> map["state"]
    self.ownerID <-> map["owner_id"]
    self.createdBy <-> map["created_by"]
    self.managedBy <-> map["managed_by"]
    self.managedAt <-> map["managed_at"]
    self.singleSystemManagementRequired <-> map["single_system_management_required"]
    self.clientIdentifier <-> map["client_identifier"]
    self.tagLabel <-> map["tag_label"]
    self.order <-> map["order"]
    self.originSpaceMUID <-> map["origin_space_muid"]
    self.targetSpaceMUID <-> map["target_space_muid"]
    self.preview <-> map["preview"]
  }
  
}

public func ==(lhs: RMLink, rhs: RMLink) -> Bool {
  if lhs.MUID == nil || rhs.MUID == nil {
    return lhs === rhs
  }
  return lhs.MUID == rhs.MUID
}

