import Foundation
import ObjectMapper


/// Type of media
public enum MediaType: String {
  /// Source of data (every other representation can be derived from it). */
  case source = "source"
  /// Reference is link to source */
  case reference = "reference"
  /// Preview is visual/graphical abstraction of source/reference */
  case preview = "preview"
  /// Summary is textual abstraction of source/reference */
  case summary = "summary"
};


/// Data state of Media object
public enum MediaDataState: Int {
  /// Client is waiting for server to provide data upload URL
  case waitingForNewUploadURL = 0
  /// Client can upload data to dataUploadURL
  case readyForDataUpload = 1
  /// Data that is in dataDownloadURL or embedData is valid for usage
  case dataValid = 2
}


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
  /// Owner user ID
  public var ownerID: Int?
  /// JSON encodec dictionary of media metadata eg. size, encoding, etc.
  public var metadata: [String: Any]?
  /// Type of media
  public var mediaType: MediaType?
  /// Validity of media data
  public var dataState: MediaDataState?
  /// Embed media binary data (only if small enough, otherwise use dataDownloadURL and dataUploadURL)
  public var embededData: Data?
  /// Download url for data (exclusive with embedData)
  public var dataDownloadURL: URL?
  /// Upload link for new data. After data is uploaded it is needed to call mark media as uploaded function.
  public var dataUploadURL: URL?
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
    self.mediaType <- map["type"]
    self.ownerID <- map["owner_id"]
    self.dataState <- map["data_state"]
    self.embededData <- map["embeded_data"]
    self.dataDownloadURL <- map["data_download_url"]
    self.dataUploadURL <- map["data_upload_url"]
    self.representedSpaceMUID <- map["represented_space_muid"]
  }

}

public func ==(lhs: Media, rhs: Media) -> Bool{
  if lhs.MUID == nil || rhs.MUID == nil {
    return lhs === rhs
  }
  return lhs.MUID == rhs.MUID
}
