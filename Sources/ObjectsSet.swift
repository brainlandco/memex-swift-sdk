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

public protocol ObjectProtocol: Hashable {
  var MUID: String? { get }
  var updatedAt: Date? { get }
}

public class ObjectsSet: JSONRepresentable {

  public var media: [Media]?
  public var spaces: [Space]?
  public var links: [Link]?
  
  public required init() {
    super.init()
  }
  
  public required init?(map: Map) {
    super.init(map: map)
  }
  
  override public func mapping(map: Map) {
    super.mapping(map: map)
    
    self.media <- map["media"]
    self.spaces <- map["spaces"]
    self.links <- map["links"]
  }
  
}
