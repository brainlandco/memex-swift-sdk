// ******************************************************************************
//
// Copyright © 2016, Adam Zdara. All rights reserved.
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

public class SpaceVisit: JSONRepresentable {
  
  // MARK: Properties
  
  public var spaceMUID: String?
  public var visitedAt: Date?
  
  // MARK: Lifecycle
  
  public required init() {
    super.init()
  }
  
  public required init?(map: Map) {
    super.init(map: map)
  }
  
  // MARK: Mapping
  
  override public func mapping(map: Map) {
    super.mapping(map: map)
    
    self.spaceMUID <- map["muid"]
    self.visitedAt <- map["visited_at"]
  }
  
}
