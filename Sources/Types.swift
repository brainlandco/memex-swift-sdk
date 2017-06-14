
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


/**
 Structure of response of pull method
 
 - parameter items: Set of items
 - parameter modelVersion: Pulled model verion. Can be stored and next time used and downloaded only diff of changes.
 - parameter totalItems: Total number of all items (all pages)
 - parameter hasMore: Flag if there is more pages
 - parameter nextOffset: Next page offset
 - parameter error: Error if something wrong happens
 
 */
public typealias PullOutputs<T> = (
  _ items: [T]?,
  _ modelVersion: Int?,
  _ totalItems: Int?,
  _ hasMore: Bool?,
  _ nextOffset: Int?,
  _ error: Swift.Error?)->()


/**
 Structure of response of push method
 
 - parameter oldModelVersion: User model version before changes were applied
 - parameter modelVersion: User model version after changes were applied
 - parameter error: Error if something wrong happens
 
 */
public typealias PushOutputs = (
  _ oldModelVersion: Int?,
  _ modelVersion: Int?,
  _ error: Swift.Error?)->()


/// Space processing mode tells when will be space processed (eg. webpage thumbnail and summary will be generated)
public enum ProcessingMode: String {
  /// No processing is required
  case no = "no"
  /// Processing will be performed asynchrounously after response is delivered
  case async = "async"
  /// Processing results will be included in response
  case sync = "sync"
}


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


