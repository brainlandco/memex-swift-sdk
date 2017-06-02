
import Foundation


/// Defines service environemnt
public enum Environment: Int {
  /// Production environment
  case production = 0
  /// Staging environment (only for testing purpuses)
  case staging = 1
  /// Local environment (only for testing purpuses)
  case local = 2
}

/// Entitity visibility state
public enum ObjectState: Int {
  /// State is unknown
  case unknown = -1
  /// Object is visible to user
  case visible = 0
  /// user is invisible for user and will be removed in near future
  case trashed = 1
}


/// Data state of Media object
public enum DataState: Int {
  /// Unknown
  case unknown = -1
  /// Client is waiting for server to provide data upload URL
  case waitingForNewUploadURL = 0
  /// Client can upload data to dataUploadURL
  case readyForDataUpload = 1
  /// Data that is in dataDownloadURL or embedData is valid for usage
  case dataValid = 2
}


/**
 Set of errors that can be returned by SDK
 */
public enum MemexError: Int, Error {
  /// Generic error
  case generic
  /// Geenric client error (4xx)
  case genericClientError
  /// Unable to parse JSON
  case JSONParsingError
  /// Generic server error (5xx)
  case genericServerError
  /// Server is under maintanance
  case serverMaintanance
  /// User is not authorized
  case notAuthorized
  /// Endpoint not found 404
  case endpointNotFound
}


/**
 - parameter error: Error if something wrong happens
 */
public typealias VoidOutputs = (_ error: Swift.Error?)->()


typealias RequestCompletion = (_ content: [String: Any]?,
  _ code: Int?,
  _ error: Swift.Error?)->()


enum HTTPMethod: String {
  case GET = "GET"
  case POST = "POST"
  case DELETE = "DELETE"
  case PUT = "PUT"
  case HEAD = "HEAD"
  case PATCH = "PATCH"
}

struct HTTPHeader {
  static let contentType = "Content-Type"
  static let userToken = "X-User-Token"
  static let appToken = "X-App-Token"
}


