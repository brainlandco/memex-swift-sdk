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

class UserUpdatesTests: XCTestCase {
  
  let memex = Memex(key: "XsL3i4Kleu2yoqfahMZMBWLCDwH3chKwPZpyDb5I",
                    secret: "0wB9WKyrTvnxB3VwuMNditWfpDM6amE1803V4FHJ",
                    environment: .staging,
                    verbose: true)
  
  override func setUp() {
    self.memex.deauthorize { (error) in }
  }
  
  func prepareAuthorizedUser(completion: @escaping (_ user: User?)->()) {
    
  }
  
  func testGetMyselfUser() {
    let expectation = self.expectation(description: "")
    
    let user = User()
    user.email = "bob@cc\(String.UUID())c.cz"
    user.authorizationToken = "test_" + String.UUID()
    user.fullname = "Bob"
    self.memex.createUser(user: user) { (error) in
      self.memex.authorize(credentials: Credentials(identifier: user.authorizationToken, secret: nil),
                           method: .iCloudToken) { (error) in
                            self.memex.getUser(userID: User.Constants.myselfUserID, completion: { (fetchedUser, error) in
                              XCTAssertNil(error)
                              XCTAssertNotNil(fetchedUser)
                              XCTAssertNotNil(fetchedUser!.ID)
                              XCTAssertNotNil(fetchedUser!.createdAt)
                              XCTAssertNotNil(fetchedUser!.updatedAt)
                              XCTAssertNil(fetchedUser!.avatar)
                              XCTAssertFalse(fetchedUser!.advanced!)
                              XCTAssertTrue(user.email == fetchedUser!.email)
                              XCTAssertTrue(user.fullname == fetchedUser!.fullname)
                              XCTAssertNil(fetchedUser!.authorizationToken)
                              XCTAssertTrue(fetchedUser!.hasPassword == false)
                              expectation.fulfill()
                            })
      }
    }
    
    self.waitForExpectations(timeout: 5) { (error) in
      if error != nil {
        XCTFail(error!.localizedDescription)
      }
    }
  }
  
  func testGetOtherUser() {
    let expectation = self.expectation(description: "")
    
    let user = User()
    user.authorizationToken = "test_" + String.UUID()
    self.memex.createUser(user: user) { (error) in
      self.memex.authorize(credentials: Credentials(identifier: user.authorizationToken, secret: nil),
                           method: .iCloudToken) { (error) in
                            self.memex.getUser(userID: 0, completion: { (fetchedUser, error) in
                              XCTAssertNotNil(error)
                              XCTAssertNil(fetchedUser)
                              expectation.fulfill()
                            })
      }
    }
    
    self.waitForExpectations(timeout: 5) { (error) in
      if error != nil {
        XCTFail(error!.localizedDescription)
      }
    }
  }
  
  func testUpdateMyself() {
    XCTFail()
  }
  
  func testSetPassword() {
    XCTFail()
  }
  
  func testChangePassword() {
    XCTFail()
  }
  
  func testAvatarCreation() {
    XCTFail()
  }
  
  func testAvatarChange() {
    XCTFail()
  }
  
}
