
import Foundation

public enum Environment: Int {
  case production = 0
  case sandbox = 1
  case staging = 2
  case localhost = 3
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

public enum Error: Int, Swift.Error {
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

public struct AuthTypes {
  static let basic = "Basic"
  static let bearer = "Bearer"
}

public enum AuthorizationMethod {
  case userCredentials
  case iCloudToken
}

public enum AuthorizationStatus: Int {
  case unknown = -1
  case notAuthorized = 0
  case authorized = 1
}

struct Permissions: OptionSet {
  let rawValue: Int
  init(rawValue: Int) {
    self.rawValue = rawValue
  }
  static let none       = Permissions(rawValue: 0)
  static let publicAccess     = Permissions(rawValue: 1 << 0)
  static let userRead   = Permissions(rawValue: 1 << 1)
  static let userWrite  = Permissions(rawValue: 1 << 2)
  static let userAll: Permissions = [userRead, userWrite]
}



