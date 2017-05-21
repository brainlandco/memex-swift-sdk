
import Foundation

public class AuthorizationController {
  
  // MARK: Properties
  
  var secretStore: KeychainSwift!
  var syncLock = Lock()
  var authorizationLock = Lock()
  var internalUserToken: String? {
    didSet {
      self.persistToken(token: self.internalUserToken)
    }
  }
  weak var spaces: Spaces?
  let tokenKey: String
  public var userToken: String? {
    return self.syncLock.withCriticalScope {
      self.internalUserToken
    }
  }
  
  // MARK: Lifecycle
  
  init(spaces: Spaces) {
    self.spaces = spaces
    self.secretStore = KeychainSwift()
    self.tokenKey = spaces.configuration.authTokenKey
  }
  
  // MARK: Bootstrap
  
  func bootstrap(allowDeauthorization: Bool, completionHandler: @escaping ()->()) {
    dispatch_async_on_main {
      self.syncLock.lock()
      self.restorePersistedToken { token in
        if self.internalUserToken != token {
          self.internalUserToken = token
          self.spaces?.emit(event: AuthorizationStatusChangedEvent(token: token))
        }
        self.syncLock.unlock()
      }
      completionHandler()
    }
  }
  
  // MARK: Authorization
  
  typealias TokenResponse = (_ token: String?, _ error: Swift.Error?)->()
  
  func authorizeWithCredentials(credentials: Credentials,
                                completionHandler: @escaping TokenResponse) {
    self.authorizeWithBodyParameters(bodyParameters: [
      "email": credentials.identifier,
      "password": credentials.secret
      ],
                                     completionHandler: completionHandler)
  }
  
  func authorizeWithBodyParameters(bodyParameters: [String: Any], completionHandler: @escaping TokenResponse) {
    self.spaces?.requestor.request(
      method: .POST,
      path: "auth/login",
      queryStringParameters: nil,
      bodyParameters: bodyParameters,
      completionHandler: { [weak self] content, code, error in
        let token = content?["token"] as? String
        if error == nil {
          self?.syncLock.withCriticalScope {
            self?.internalUserToken = token
          }
        }
        completionHandler(token, error)
    })
  }
  
  func deauthorize() {
    self.syncLock.withCriticalScope {
      self.internalUserToken = nil
    }
  }
  
  // MARK: Access Token Persistency
  
  private func restorePersistedToken(completion: @escaping (String?)->()) {
    let token = self.secretStore.get(self.tokenKey)
    if self.secretStore.lastResultCode != noErr {
      NSLog("Failed to read from Keychain: \(self.secretStore.lastResultCode). try after 0.1s")
      dispatch_async_on_main(delay: 0.5) { //https://forums.developer.apple.com/thread/4743
        let token = self.secretStore.get(self.tokenKey)
        if self.secretStore.lastResultCode != noErr {
          NSLog("Failed to read from Keychain again: \(self.secretStore.lastResultCode). try after 0.5s")
          dispatch_async_on_main(delay: 1.5) {
            let token = self.secretStore.get(self.tokenKey)
            completion(token)
          }
        } else {
          completion(token)
        }
      }
    } else {
      completion(token)
    }
  }
  
  private func persistToken(token: String?) {
    do {
      if let token = token {
        // remove always access options after //https://forums.developer.apple.com/thread/4743 is fixed
        if !self.secretStore.set(token, forKey: self.tokenKey, withAccess: KeychainSwiftAccessOptions.accessibleAlways) {
          if self.secretStore.lastResultCode != noErr {
            NSLog("Failed to write token to Keychain: \(self.secretStore.lastResultCode).")
          }
          throw MemexError.generic
        }
      } else {
        self.secretStore.delete(self.tokenKey)
      }
    } catch {
      NSLog("Unable to store token")
    }
  }
  
}



