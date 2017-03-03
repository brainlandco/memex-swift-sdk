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

public enum ManagementEntity: Int {
  case user = 0
  case system = 1
}

public enum DataState: Int {
  case Unknown = -1
  case WaitingForNewUploadURL = 0
  case ReadyForDataUpload = 1
  case DataValid = 2
}

public enum Error: Int, Swift.Error {
  case Generic
  case ServerMaintanance
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


