/**
 *
 * Copyright (c) 2016, Adam Zdara.
 * Created by: Adam Zdara on 05/05/16
 *
 * All rights reserved. This source code can be used only for purposes specified
 * by the given license contract signed by the rightful deputy of Adam Zdara.
 * This source code can be used only by the owner of the license.
 *
 * Any disputes arising in respect of this agreement (license) shall be brought
 * before the Municipal Court of Prague.
 *
 */

import Foundation

public enum Error: Int, ErrorType {
  case Generic
  case GenericClientError
  case GenericServerError
  case ServerMaintanance
  case JSONParsingError
  
  case MissingID
  case EmailAlreadyExists
  case iCloudIDAlreadyExists
  case InvalidPassword
  case EndpointNotFound
  case ObjectNotFound
  case MasterRepresentationNotFound
  case NotAuthorized
  case InvalidData
  case InvalidInvitationToken
}

public enum HTTPMethod: String {
  case GET = "GET"
  case POST = "POST"
  case DELETE = "DELETE"
  case PUT = "PUT"
  case HEAD = "HEAD"
  case PATCH = "PATCH"
}

public struct StandardHTTPHeader {
  static let UserAgent = "User-Agent"
  static let Authorization = "Authorization"
  static let ContentType = "Content-Type"
}

public struct AuthTypes {
  static let Basic = "Basic"
  static let Bearer = "Bearer"
}

public enum AuthorizationStatus: Int {
  case Unknown = -1
  case NotAuthorized = 0
  case AuthorizedForPublicActions = 1
  case AuthorizedForUserActions = 2
}

enum InternalAuthorizationStatus {
  case Unknown
  case NotAuthorized
  case Authorized
}

public enum RepresentationProcessingState: Int {
  case Done = 0
  case Waiting = 1
}

public enum PresentationStyle: Int {
  case List = 0
  case Grid = 1
}

public struct Constants {
  public static let SELF_ID = -1
}

public enum ObjectState: Int {
  case Unknown = -1
  case Visible = 0
  case Trashed = 1
}

public enum RMManagementEntity: Int {
  case user = 0
  case system = 1
}

public enum DataState: Int {
  case Unknown = -1
  case WaitingForNewUploadURL = 0
  case ReadyForDataUpload = 1
  case DataValid = 2
}

struct Permissions: OptionSetType {
  let rawValue: Int
  init(rawValue: Int) {
    self.rawValue = rawValue
  }
  static let None       = Permissions(rawValue: 0)
  static let Public     = Permissions(rawValue: 1 << 0)
  static let UserRead   = Permissions(rawValue: 1 << 1)
  static let UserWrite  = Permissions(rawValue: 1 << 2)
  static let UserAll: Permissions = [UserRead, UserWrite]
}

