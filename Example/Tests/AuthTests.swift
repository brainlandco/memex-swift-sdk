import UIKit
import XCTest
import MemexSwiftSDK

class AuthTests: BaseTestCase {
  
  func testIsLoggedIn() {
    let expectation1 = expectation(description: "default")
    self.prepareSDK { (memex, myself) in
      memex.isLoggedIn(completion: { (loggedIn, error) in
        XCTAssertNil(error, "request failed")
        XCTAssertTrue(loggedIn == false, "wrong value")
        expectation1.fulfill()
      })
    }
    waitForExpectations(timeout: Constants.timeout, handler: nil)
  }
  
  func testInvalidCredentialsLogin() {
    let expectation1 = expectation(description: "default")
    self.prepareSDK { (memex, myself) in
      memex.loginUserWithUserCredentials(credentials: Credentials(identifier: UUID().uuidString, secret: UUID().uuidString), completion: { (retryToken, error) in
        XCTAssertNotNil(error, "request succeeded")
        expectation1.fulfill()
      })
    }
    waitForExpectations(timeout: Constants.timeout, handler: nil)
  }
  
  func testInvalidOnboardingTokenLogin() {
    let expectation1 = expectation(description: "default")
    self.prepareSDK { (memex, myself) in
      memex.loginUserWithOnboardingToken(token: UUID().uuidString, completion: { (retryToken, error) in
        XCTAssertNotNil(error, "request succeeded")
        expectation1.fulfill()
      })
    }
    waitForExpectations(timeout: Constants.timeout, handler: nil)
  }
  

  func testValidCredentialsLogin() {
    let expectation1 = expectation(description: "default")
    self.prepareSDK { (memex, myself) in
      let credentials = Credentials(identifier: self.mockEmail(), secret: self.mockPassword())
      let user = User()
      user.email = credentials.identifier
      user.password = credentials.secret
      memex.createUser(user: user, onboardingToken: nil, completion: { (user, error) in
        XCTAssertNil(error, "request failed")
        XCTAssertNotNil(user, "missing user")
        XCTAssertTrue(user?.hasPassword == true, "wrong hasPassword")
        memex.loginUserWithUserCredentials(credentials: credentials, completion: { (retryToken, error) in
          XCTAssertNil(error, "request failed")
          expectation1.fulfill()
        })
      })
    }
    waitForExpectations(timeout: Constants.timeout, handler: nil)
  }
  
  
  func testValidOnboardingTokenLogin() {
    let expectation1 = expectation(description: "default")
    self.prepareSDK { (memex, myself) in
      let onboardingToken = UUID().uuidString
      let user = User()
      memex.createUser(user: user, onboardingToken: onboardingToken, completion: { (user, error) in
        XCTAssertNil(error, "request failed")
        XCTAssertNotNil(user, "missing user")
        XCTAssertTrue(user?.hasPassword == false, "wrong hasPassword")
        memex.loginUserWithOnboardingToken(token: onboardingToken, completion: { (retryToken, error) in
          XCTAssertNil(error, "request failed")
          expectation1.fulfill()
        })
      })
    }
    waitForExpectations(timeout: Constants.timeout, handler: nil)
  }
  
}
