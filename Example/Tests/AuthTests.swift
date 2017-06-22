import UIKit
import XCTest
import MemexSwiftSDK

class AuthTests: BaseTestCase {
  
  func testInvalidCredentialsLogin() {
    let expectation1 = expectation(description: "default")
    self.prepareSDK { (memex) in
      memex.loginUserWithUserCredentials(credentials: Credentials(identifier: UUID().uuidString, secret: UUID().uuidString), completion: { (error) in
        XCTAssertNotNil(error, "request succeeded")
        expectation1.fulfill()
      })
    }
    waitForExpectations(timeout: 10, handler: nil)
  }
  
  func testInvalidOnboardingTokenLogin() {
    let expectation1 = expectation(description: "default")
    self.prepareSDK { (memex) in
      memex.loginUserWithOnboardingToken(token: UUID().uuidString, completion: { (error) in
        XCTAssertNotNil(error, "request succeeded")
        expectation1.fulfill()
      })
    }
    waitForExpectations(timeout: 10, handler: nil)
  }
  

  func testValidCredentialsLogin() {
    let expectation1 = expectation(description: "default")
    self.prepareSDK { (memex) in
      let credentials = Credentials(identifier: UUID().uuidString, secret: UUID().uuidString)
      let user = User()
      user.email = credentials.identifier
      user.password = credentials.secret
      memex.createUser(user: user, onboardingToken: nil, completion: { (user, error) in
        XCTAssertNil(error, "request failed")
        XCTAssertNotNil(user, "missing user")
        memex.loginUserWithUserCredentials(credentials: credentials, completion: { (error) in
          XCTAssertNil(error, "request failed")
          expectation1.fulfill()
        })
      })
    }
    waitForExpectations(timeout: 10, handler: nil)
  }
  
  
  func testValidOnboardingTokenLogin() {
    let expectation1 = expectation(description: "default")
    self.prepareSDK { (memex) in
      let onboardingToken = UUID().uuidString
      let user = User()
      memex.createUser(user: user, onboardingToken: onboardingToken, completion: { (user, error) in
        XCTAssertNil(error, "request failed")
        XCTAssertNotNil(user, "missing user")
        memex.loginUserWithOnboardingToken(token: onboardingToken, completion: { (error) in
          XCTAssertNil(error, "request failed")
          expectation1.fulfill()
        })
      })
    }
    waitForExpectations(timeout: 10, handler: nil)
  }
  
}
