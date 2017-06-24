import UIKit
import XCTest
import MemexSwiftSDK

class BaseTestCase: XCTestCase {
  
  var memex: Memex!
  
  struct Constants {
    static let appToken = "c82070e09366bc37f7da0a275895955a7ec8d3c0"
    static let timeout: TimeInterval = 30
  }
  
  func prepareSDK(authorize: Bool = false, completion: @escaping (_ memex: Memex, _ myself: User?) -> ()) {
    self.memex = Memex(appToken: Constants.appToken, environment: .staging, verbose: true)
    self.memex.prepare { error in
      XCTAssertNil(error, "nonnil error")
      self.memex.logout { error in
        XCTAssertNil(error, "nonnil error")
        if !authorize {
          completion(self.memex, nil)
        } else {
          let user = User()
          let onboardingToken = UUID().uuidString
          self.memex.createUser(user: user, onboardingToken: onboardingToken, completion: { (newUser, error) in
            XCTAssertNil(error, "nonnil error")
            self.memex.loginUserWithOnboardingToken(token: onboardingToken, completion: { (error) in
              XCTAssertNil(error, "nonnil error")
              completion(self.memex, newUser)
            })
          })
        }
      }
    }
  }
  
}
