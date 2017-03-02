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
import UIKit

public class WebpageMetadata: SUEntity {
  
  public var title: String?
  public var summary: String?
  public var tintColor: UIColor?
  public var thumbnailURL: NSURL?
  public var thumbnailWidth: CGFloat?
  public var thumbnailHeight: CGFloat?
  
  public required init() {
    super.init()
  }
  
  public required init?(_ map: SUMap) {
    super.init(map)
  }
  
  override public func mapping(map: SUMap) {
    super.mapping(map)
    
    self.title <-> map["caption"]
    self.summary <-> map["preview_text"]
    self.tintColor <-> map["tint_color"]
    self.thumbnailURL <-> map["preview_url"]
    self.thumbnailWidth <-> map["preview_width"]
    self.thumbnailHeight <-> map["preview_height"]
  }
  
}
