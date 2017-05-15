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
import Sushi
import ObjectMapper

public class User: JSONRepresentable {
  
  public struct Constants {
    public static let myselfUserID = -1
  }
  
  public var ID: Int?
  public var fullname: String?
  public var email: String?
  public var hasPassword: Bool?
  public var advanced: Bool?
  public var avatar: Media?
  public var originSpaceMUID: String?
  public var createdAt: Date?
  public var updatedAt: Date?
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
    self.hasPassword <- map["has_password"]
    self.avatar <- map["avatar"]
    self.advanced <- map["advanced"]
  }
   
}

public func ==(lhs: User, rhs: User) -> Bool {
  if lhs.ID == nil || rhs.ID == nil {
    return lhs === rhs
  }
  return lhs.ID == rhs.ID
}
