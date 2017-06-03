import Foundation
import ObjectMapper

/// Object that represents any multimedia
public class Media: JSONRepresentable, ObjectProtocol {
  
  /// Unique identifier
  public var MUID: String?
  /// Creation timestamp
  public var createdAt: Date?
  /// Last update timestamp
  public var updatedAt: Date?
  /// Visibility state
  public var state: ObjectState?
  /// Dictionary of media metadata eg. size, encoding, etc.
  public var metadata: [String: Any]?
  /// Validity of media data
  public var dataState: DataState?
  /// Defines semantic type of media (reference, source, thumbnail, summary, etc.)
  public var kind: String?
  /// If data is small enough to be encoded into object using Base64
  public var embededData: Data?
  /// Download link for data (exclusive with embedData)
  public var dataDownloadURL: URL?
  /// Upload link for new data. After data is uploaded it is needed to call mark media as uploaded function.
  public var dataUploadURL: URL?
  /// Media owner ID
  public var ownerID: Int?
  /// If media represents any space then its MUID is present
  public var representedSpaceMUID: String?
  public override var hashValue: Int {
    return self.MUID!.hashValue
  }
  
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
    self.kind <- map["type"]
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
