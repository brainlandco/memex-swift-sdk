import UIKit
import XCTest
import MemexSwiftSDK

class SessionsTests: BaseTestCase {
  
  func testSessionsPull() {
    let expectation1 = expectation(description: "default")
    self.prepareSDK(authorize: true) { (memex, myself) in
      memex.getSessions(completion: { (sessions, error) in
        XCTAssertNil(error, "request failed")
        XCTAssertTrue(sessions!.count == 1, "wrong number of sessions")
        expectation1.fulfill()
      })
    }
    waitForExpectations(timeout: Constants.timeout, handler: nil)
  }


}

