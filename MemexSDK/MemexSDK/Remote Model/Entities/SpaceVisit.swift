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

public class RMSpaceVisit: SUEntity {
  
  // MARK: Properties
  
  public var spaceMUID: String?
  public var visitedAt: NSDate?
  
  // MARK: Lifecycle
  
  public required init()
  {
    super.init()
  }
  
  public required init?(_ map: SUMap)
  {
    super.init(map)
  }
  
  // MARK: Mapping
  
  override public func mapping(map: SUMap)
  {
    super.mapping(map)
    
    self.spaceMUID <-> map["muid"]
    self.visitedAt <-> map["visited_at"]
  }
  
}
