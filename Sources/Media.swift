// ******************************************************************************
//
// Copyright © 2015, Adam Zdara. All rights reserved.
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

public class Media: JSONRepresentable, ObjectProtocol {
  
  public var MUID: String?
  public override var hashValue: Int {
    return self.MUID!.hashValue
  }
  public var createdAt: Date?
  public var updatedAt: Date?
  public var state: ObjectState?
  public var metadata: [String: Any]?
  public var dataState: DataState?
  public var tag: String?
  public var embededData: Data?
  public var dataDownloadURL: URL?
  public var dataUploadURL: URL?
  public var ownerID: Int?
  public var representedSpaceMUID: String?
  
  public required init() {
    super.init()
  }
  
  public required init?(map: Map) {
    super.init(map: map)
  }
  
  override public func mapping(map: Map) {
    self.MUID <- map["muid"]
    self.createdAt <- map["created_at"]
    self.updatedAt <- map["updated_at"]
    self.state <- map["state"]
    self.metadata <- (map["metadata"], EncodedJSONTransform())
    self.tag <- map["type"]
    self.dataState <- map["data_state"]
    self.embededData <- map["embeded_data"]
    self.dataDownloadURL <- map["data_download_url"]
    self.dataUploadURL <- map["data_upload_url"]
    self.ownerID <- map["owner_id"]
    self.representedSpaceMUID <- map["represented_space_muid"]
  }

}

public func ==(lhs: Media, rhs: Media) -> Bool{
  if lhs.MUID == nil || rhs.MUID == nil {
    return lhs === rhs
  }
  return lhs.MUID == rhs.MUID
}
