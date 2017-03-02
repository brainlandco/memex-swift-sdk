/**
 *
 * Copyright (c) 2015, Adam Zdara.
 * Created by: Adam Zdara on 16.12.2015
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
import KeychainSwift

public class Auth {
  
  // MARK: Types
  
  struct Constants {
    #if PRODUCTION
     static let TokenKey = "SUAuthorizationController.token"
     static let FirstLaunchKey = "TPRMAuthorizationManagerFirstLaunch"
    #else
     static let TokenKey = "SUAuthorizationController.token.dev"
     static let FirstLaunchKey = "TPRMAuthorizationManagerFirstLaunch.dev"
    #endif
  }
  
  // MARK: Properties
  
  var secretStore: KeychainSwift!
  var syncLock = ATLock()
  var authorizationLock = ATLock()
  var internalAuthorizationStatus = SUInternalAuthorizationStatus.Unknown
  var internalToken: SUToken? {
    didSet {
      self.persistToken(self.internalToken)
    }
  }
  weak var module: SUModule?
  
  // MARK: Lifecycle
  
  init(module: SUModule) {
    self.module = module
    self.secretStore = KeychainSwift()
  }
  
  // MARK: Bootstrap
  
  func bootstrap(allowDeauthorization allowDeauthorization: Bool, completionHandler: ()->()) {
    dispatch_async_on_main {
      self.syncLock.lock()
      self.restorePersistedToken { token in
        self.internalToken = token
        let newState: SUInternalAuthorizationStatus = self.internalToken == nil ? .NotAuthorized : .Authorized
        if self.internalAuthorizationStatus != newState {
          self.internalAuthorizationStatus = newState
          SUAuthorizationStatusChangedEvent(status: self.externalAuthorizationStatus(lock: false))
            .publishOn(self.module!.eventQueue)
        }
        self.syncLock.unlock()
      }
      completionHandler()
    }
  }
  
  // MARK: Authorization
  
  func authorizeRequest(request: NSMutableURLRequest, completionHandler: (ErrorType?)->()) {
    self.authorizationLock.lock()
    self.syncLock.lock()
    if self.internalAuthorizationStatus == .Authorized {
      self.addAuthorizationHeaderToRequest(request, usingToken: self.internalToken!)
      completionHandler(nil)
      self.syncLock.unlock()
      self.authorizationLock.unlock()
    } else {
      self.syncLock.unlock()
      self.authorizeForPublicScopeTokenWithCompletion({ [weak self] (token, error) -> () in
        if error == nil {
          self!.addAuthorizationHeaderToRequest(request, usingToken: token!)
          completionHandler(nil)
        } else {
          completionHandler(error)
        }
        self!.authorizationLock.unlock()
        })
    }
  }
  
  func addAuthorizationHeaderToRequest(request: NSMutableURLRequest, usingToken token: SUToken) {
    request.setValue(self.authorizationHeader(token: token), forHTTPHeaderField: SUStandardHTTPHeader.Authorization)
  }

  func authorizationHeader(userIdentifier userIdentifier: String, secret: String) -> String {
    let basicAuthCredentials = "\(userIdentifier):\(secret)"
    let data = basicAuthCredentials.dataUsingEncoding(NSUTF8StringEncoding)!
    let string = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions())
    return "\(SUAuthorizationTypes.Basic) \(string)"
  }
  
  func authorizationHeader(token token: SUToken) -> String {
    return "\(SUAuthorizationTypes.Bearer) \(token.secret!)"
  }
  
  typealias TokenResponse = (token: SUToken?, error: ErrorType?)->()
  
  func authorizeForPublicScopeTokenWithCompletion(completionHandler: TokenResponse) {
    self.authorizeWithBodyParameters([
      "grant_type": "client_credentials"
      ],
      completionHandler: completionHandler)
  }
  
  func authorizeForUserScopeTokenWithCredentials(credentials: ATCredentials, completionHandler: TokenResponse) {
    self.authorizeWithBodyParameters([
      "grant_type": "password",
      "email": credentials.identifier,
      "password": credentials.secret,
      ],
      completionHandler: completionHandler)
  }
  
  func authorizeForUserScopeTokenWithUUID(UUID: String, completionHandler: TokenResponse) {
    self.authorizeWithBodyParameters([
      "grant_type": "account_uuid",
      "uuid": UUID,
      ],
      completionHandler: completionHandler)
  }
  
  func authorizeWithBodyParameters(bodyParameters: [String: AnyObject], completionHandler: TokenResponse) {
    if !self.beginAuthorizationIfPossible() {
      return
    }
    let authorizationHeader = self.authorizationHeader(
      userIdentifier: self.module!.configuration.clientCredentials.identifier,
      secret: self.module!.configuration.clientCredentials.secret
    )
    self.module?.requestInvoker.request(
      method: .POST,
      path: "oauth/token",
      queryStringParameters: nil,
      bodyParameters: bodyParameters,
      authorize: false,
      authorizationHeaderValue: authorizationHeader,
      completionHandler: { [weak self] content, code, error in
        var token: SUToken? = nil
        if error == nil {
          self?.syncLock.withCriticalScope {
            token = SUToken(JSON: content!)
            self?.internalToken = token
            self?.internalAuthorizationStatus = .Authorized
          }
        }
        completionHandler(token: token, error: error)
    })
  }
  
  func beginAuthorizationIfPossible() -> Bool {
    var result: Bool!
    self.syncLock.withCriticalScope {
      if self.internalAuthorizationStatus == .Unknown {
        result = false
      } else {
        result = true
      }
    }
    return result
  }
  
  func deauthorize() {
    self.syncLock.withCriticalScope {
      self.internalToken = nil
      if self.internalAuthorizationStatus != .NotAuthorized {
        self.internalAuthorizationStatus = .NotAuthorized
        SUAuthorizationStatusChangedEvent(status: self.externalAuthorizationStatus(lock: false))
          .publishOn(self.module!.eventQueue)
      }
    }
  }
  
  func externalAuthorizationStatus(lock lock: Bool) -> SUAuthorizationStatus {
    var value: SUInternalAuthorizationStatus = .Unknown
    var token: SUToken!
    if lock {
      self.syncLock.withCriticalScope {
        value = self.internalAuthorizationStatus
        token = self.internalToken
      }
    } else {
      value = self.internalAuthorizationStatus
      token = self.internalToken
    }
    var status: SUAuthorizationStatus = .Unknown
    switch value {
    case SUInternalAuthorizationStatus.Unknown:
      status = .Unknown
    case SUInternalAuthorizationStatus.NotAuthorized:
      status = .NotAuthorized
    case SUInternalAuthorizationStatus.Authorized:
      let permissions = token.permissions
      let hasUserAuthorization = permissions.contains(.UserRead) && permissions.contains(.UserWrite)
      status = hasUserAuthorization ? .AuthorizedForUserActions : .AuthorizedForPublicActions
    }
    return status
  }
  
  // MARK: Access Token Persistency
  
  private func restorePersistedToken(completion: (SUToken?)->()) {
    let data = self.secretStore.getData(Constants.TokenKey)
    if self.secretStore.lastResultCode != noErr {
      ALLog("Failed to read from Keychain: \(self.secretStore.lastResultCode). try after 0.1s")
      dispatch_async_on_main(delay: 0.5) { //https://forums.developer.apple.com/thread/4743
        let data = self.secretStore.getData(Constants.TokenKey)
        if self.secretStore.lastResultCode != noErr {
          ALLog("Failed to read from Keychain again: \(self.secretStore.lastResultCode). try after 0.5s")
          dispatch_async_on_main(delay: 1.5) {
            let data = self.secretStore.getData(Constants.TokenKey)
            self.restorePersistedTokenFromData(data, completion: completion)
          }
        } else {
          self.restorePersistedTokenFromData(data, completion: completion)
        }
      }
    } else {
      self.restorePersistedTokenFromData(data, completion: completion)
    }
  }
  
  private func restorePersistedTokenFromData(data: NSData?, completion: (SUToken?)->()) {
    guard let value = data else {
      completion(nil)
      return
    }
    do {
      let json = try NSJSONSerialization.JSONObjectWithData(value, options: [])
      if let token = SUToken(JSON: json as! [String : AnyObject]) {
        completion(token)
      } else {
        completion(nil)
      }
    } catch {
      completion(nil)
    }
  }
  
  
  private func persistToken(token: SUToken?) {
    do {
      if let json = token?.toJSON() {
        let data = try NSJSONSerialization.dataWithJSONObject(json, options: [])
        // remove always access options after //https://forums.developer.apple.com/thread/4743 is fixed
        if !self.secretStore.set(data, forKey: Constants.TokenKey, withAccess: KeychainSwiftAccessOptions.AccessibleAlways) {
          if self.secretStore.lastResultCode != noErr {
            ALLog("Failed to write token to Keychain: \(self.secretStore.lastResultCode).")
          }
          throw SUError.Generic
        }
      } else {
        self.secretStore.delete(Constants.TokenKey)
      }
    } catch {
      ALLog("Unable to store token")
    }
  }

}



