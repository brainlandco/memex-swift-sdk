
import Foundation

public enum Environment: Int {
  case production = 0
  case staging = 1
  case local = 2
}

public enum ObjectState: Int {
  case unknown = -1
  case visible = 0
  case trashed = 1
}

public enum DataState: Int {
  case unknown = -1
  case waitingForNewUploadURL = 0
  case readyForDataUpload = 1
  case dataValid = 2
}

public enum MemexError: Int, Error {
  case generic
  case serverMaintanance
  case missingID
  case emailAlreadyExists
  case iCloudIDAlreadyExists
  case invalidPassword
  case endpointNotFound
  case objectNotFound
  case masterRepresentationNotFound
  case notAuthorized
  case invalidData
  case invalidInvitationToken
  
  case genericClientError
  case JSONParsingError
  
  case genericServerError
}


public typealias VoidOutputs = (_ error: Swift.Error?)->()

public typealias RequestCompletion = (_ content: [String: Any]?,
  _ code: Int?,
  _ error: Swift.Error?)->()


public enum HTTPMethod: String {
  case GET = "GET"
  case POST = "POST"
  case DELETE = "DELETE"
  case PUT = "PUT"
  case HEAD = "HEAD"
  case PATCH = "PATCH"
}

public struct StandardHTTPHeader {
  static let userAgent = "User-Agent"
  static let authorization = "Authorization"
  static let contentType = "Content-Type"
}


