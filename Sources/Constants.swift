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
}


