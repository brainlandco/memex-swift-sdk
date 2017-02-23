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

public class RMMedia: SUEntity, RMObjectProtocol {
  
  public var MUID: String?
  public override var hashValue: Int {
    return self.MUID!.hashValue
  }
  public var createdAt: NSDate?
  public var updatedAt: NSDate?
  public var state: RMObjectState?
  public var createdBy: RMManagementEntity?
  public var managedBy: RMManagementEntity?
  public var managedAt: NSDate?
  public var singleSystemManagementRequired: Bool?
  public var clientIdentifier: String?
  public var metadata: [String: AnyObject]?
  public var dataState: DataState?
  public var tag: String?
  public var embededData: NSData?
  public var dataDownloadURL: NSURL?
  public var dataUploadURL: NSURL?
  public var ownerID: Int?
  public var representedSpaceMUID: String?
  
  public required init() {
    super.init()
  }
  
  public required init?(_ map: SUMap) {
    super.init(map)
  }
  
  override public func mapping(map: SUMap) {
    self.MUID <-> map["muid"]
    self.createdAt <-> map["created_at"]
    self.updatedAt <-> map["updated_at"]
    self.state <-> map["state"]
    self.createdBy <-> map["created_by"]
    self.managedBy <-> map["managed_by"]
    self.managedAt <-> map["managed_at"]
    self.singleSystemManagementRequired <-> map["single_system_management_required"]
    self.clientIdentifier <-> map["client_identifier"]
    self.metadata <-> (map["metadata"], HIMetadataTransform())
    self.tag <-> map["type"]
    self.dataState <-> map["data_state"]
    self.embededData <-> map["embeded_data"]
    self.dataDownloadURL <-> map["data_download_url"]
    self.dataUploadURL <-> map["data_upload_url"]
    self.ownerID <-> map["owner_id"]
    self.representedSpaceMUID <-> map["represented_space_muid"]
  }

}

public class HIMetadataTransform: SUTransformType {
  
  public typealias Object = [String: AnyObject]
  public typealias JSON = String
  
  public init() {}
  
  public func transformFromJSON(value: AnyObject?) -> [String: AnyObject]? {
    if let string = value as? String {
      do {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding)!
        let object = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! [String: AnyObject]
        return object
      }
      catch {
        return nil
      }
    }
    return nil
  }
  
  public func transformToJSON(value: [String: AnyObject]?) -> String? {
    if let value = value {
      let data = try! NSJSONSerialization.dataWithJSONObject(value, options: [])
      let string = String(data: data, encoding: NSUTF8StringEncoding)
      return string
    }
    return nil
  }
  
}

public func ==(lhs: RMMedia, rhs: RMMedia) -> Bool{
  if lhs.MUID == nil || rhs.MUID == nil {
    return lhs === rhs
  }
  return lhs.MUID == rhs.MUID
}
