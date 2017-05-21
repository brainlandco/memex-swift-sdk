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

class AuthorizationTests: XCTestCase {
  
  let memex = Memex(key: "XsL3i4Kleu2yoqfahMZMBWLCDwH3chKwPZpyDb5I",
                    secret: "0wB9WKyrTvnxB3VwuMNditWfpDM6amE1803V4FHJ",
                    environment: .staging,
                    verbose: true)
  
  override func setUp() {
    self.memex.deauthorize { (error) in
    }
  }
  
  func testUserCreation() {
    let user = User()
    user.authorizationToken = "test_" + String.UUID()
    let expectation = self.expectation(description: "")
    self.memex.createUser(user: user) { (error) in
                      XCTAssertNil(error)
                      expectation.fulfill()
    }
    self.waitForExpectations(timeout: 2) { (error) in
      if error != nil {
        XCTFail(error!.localizedDescription)
      }
    }
  }
  
  func testUserCreationWithoutToken() {
    let user = User()
    let expectation = self.expectation(description: "")
    self.memex.createUser(user: user) { (error) in
      XCTAssertNotNil(error)
      XCTAssertTrue(error! as NSError == Error.genericClientError as NSError)
      expectation.fulfill()
    }
    self.waitForExpectations(timeout: 2) { (error) in
      if error != nil {
        XCTFail(error!.localizedDescription)
      }
    }
  }
  
  func testUnknownUserAuthorizationWithUserCredentials() {
    let expectation = self.expectation(description: "")
    self.memex.authorize(credentials: Credentials(identifier: "someone", secret: "password"),
                         method: .userCredentials) { (error) in
                          XCTAssertNotNil(error)
                          XCTAssertTrue(error! as NSError == Error.genericClientError as NSError)
                          expectation.fulfill()
    }
    self.waitForExpectations(timeout: 2) { (error) in
      if error != nil {
        XCTFail(error!.localizedDescription)
      }
    }
  }
  
  func testUnknownUserAuthorization() {
    let authorizationToken = "test_" + String.UUID()
    let expectation = self.expectation(description: "")
    self.memex.authorize(credentials: Credentials(identifier: authorizationToken, secret: nil),
                         method: .iCloudToken) { (error) in
                            XCTAssertNotNil(error)
                            XCTAssertTrue(error! as NSError == Error.genericClientError as NSError)
                            expectation.fulfill()
    }
    self.waitForExpectations(timeout: 2) { (error) in
      if error != nil {
        XCTFail(error!.localizedDescription)
      }
    }
  }
  
  func testKnownUserAuthorization() {
    let user = User()
    user.authorizationToken = "test_" + String.UUID()
    let expectation = self.expectation(description: "")
    self.memex.createUser(user: user) { (error) in
                            XCTAssertNil(error)
                            self.memex.authorize(credentials: Credentials(identifier: user.authorizationToken, secret: nil),
                                                 method: .iCloudToken) { (error) in
                                                  XCTAssertNil(error)
                                                  expectation.fulfill()
                            }
    }
    self.waitForExpectations(timeout: 2) { (error) in
      if error != nil {
        XCTFail(error!.localizedDescription)
      }
    }
  }
  
  func testAuthorizationLoad() {
    let expectation = self.expectation(description: "")
    let group = DispatchGroup()
    for index in 0..<100 {
      group.enter()
      let user = User()
      user.authorizationToken = "test_\(index)_" + String.UUID()
      self.memex.createUser(user: user) { (error) in
        XCTAssertNil(error)
        self.memex.authorize(credentials: Credentials(identifier: user.authorizationToken, secret: nil),
                             method: .iCloudToken) { (error) in
                              XCTAssertNil(error)
                              group.leave()
        }
      }
    }
    group.notify(queue: DispatchQueue.main, execute: { 
      expectation.fulfill()
    })
    self.waitForExpectations(timeout: 60) { (error) in
      if error != nil {
        XCTFail(error!.localizedDescription)
      }
    }
  }
  
  func testAuthorizationStatus() {
    let user = User()
    user.authorizationToken = "test_" + String.UUID()
    let expectation = self.expectation(description: "")
    self.memex.getAuthorizationStatus { status, error in
      XCTAssertNil(error)
      XCTAssertTrue(status == .notAuthorized)
      self.memex.createUser(user: user) { (error) in
        XCTAssertNil(error)
        self.memex.authorize(credentials: Credentials(identifier: user.authorizationToken, secret: nil),
                             method: .iCloudToken) { (error) in
                              self.memex.getAuthorizationStatus { status, error in
                                XCTAssertNil(error)
                                XCTAssertTrue(status == .authorizedForUserActions)
                                expectation.fulfill()
                              }
        }
      }
    }
    self.waitForExpectations(timeout: 2) { (error) in
      if error != nil {
        XCTFail(error!.localizedDescription)
      }
    }
  }
  
  func testAuthorizationWithTokenRateLimiting() {
    XCTFail()
  }
  
  func testUniqueEmailUserCreation() {
    XCTFail()
  }
  
  func testUniqueiCloudTokenUserCreation() {
    XCTFail()
  }
  
}
