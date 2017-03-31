//
//  CreateUserTests.swift
//  MemexSDK
//
//  Created by Adam Zdara on 06/03/2017.
//
//

@testable import MemexSDK
import XCTest
import Atom
import Sushi

class UserOtherTests: XCTestCase {
  
  let memex = Memex(key: "XsL3i4Kleu2yoqfahMZMBWLCDwH3chKwPZpyDb5I",
                    secret: "0wB9WKyrTvnxB3VwuMNditWfpDM6amE1803V4FHJ",
                    environment: .staging,
                    verbose: true)
  
  override func setUp() {
    self.memex.deauthorize { (error) in
    }
  }
  
  func prepareAuthorizedUser(email: String? = nil, completion: @escaping (_ user: User?)->()) {
    let user = User()
    user.email = email
    user.authorizationToken = "test_" + String.UUID()
    self.memex.createUser(user: user) { (error) in
      self.memex.authorize(credentials: Credentials(identifier: user.authorizationToken, secret: nil),
                           method: .iCloudToken) { (error) in
                            completion(user)
      }
    }
  }
  
  func testBackupRequest() {
    let expectation = self.expectation(description: "")
    self.prepareAuthorizedUser(email: "test@memex-te\(String.UUID())st.com") { (user) in
      self.memex.requestBackup { (error) in
        XCTAssertNil(error)
        expectation.fulfill()
      }
    }
    self.waitForExpectations(timeout: 5) { (error) in
      if error != nil {
        XCTFail(error!.localizedDescription)
      }
    }
  }
  
  func testBackupRequestWithoutEmail() {
    let expectation = self.expectation(description: "")
    self.prepareAuthorizedUser(email: nil) { (user) in
      self.memex.requestBackup { (error) in
        XCTAssertNotNil(error)
        expectation.fulfill()
      }
    }
    self.waitForExpectations(timeout: 5) { (error) in
      if error != nil {
        XCTFail(error!.localizedDescription)
      }
    }
  }
  
}
