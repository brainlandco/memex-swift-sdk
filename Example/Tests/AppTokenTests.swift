import UIKit
import XCTest
import MemexSwiftSDK

class AppTokenTests: BaseTestCase {
  
  func testPrepare() {
    let expectation1 = expectation(description: "default")
    prepareSDK { memex in
      expectation1.fulfill()
    }
    waitForExpectations(timeout: Constants.timeout, handler: nil)
  }
  
  func testValidAppToken() {
    let expectation1 = expectation(description: "default")
    self.prepareSDK { memex, myself in
      let user = User()
      memex.createUser(user: user, onboardingToken: UUID().uuidString, completion: { (user, error) in
        XCTAssertNil(error, "request failed")
        expectation1.fulfill()
      })
    }
    waitForExpectations(timeout: Constants.timeout, handler: nil)
  }
  
  func testInvalidAppToken() {
    let expectation1 = expectation(description: "default")
    let memex = Memex(appToken: "invalid-token", environment: .staging, verbose: true)
    memex.prepare { error in
      XCTAssertNil(error, "nonnil error")
      let user = User()
      memex.createUser(user: user, onboardingToken: UUID().uuidString, completion: { (user, error) in
        XCTAssertNotNil(error, "request succeeded")
        expectation1.fulfill()
      })
    }
    waitForExpectations(timeout: Constants.timeout, handler: nil)
  }
  
}
