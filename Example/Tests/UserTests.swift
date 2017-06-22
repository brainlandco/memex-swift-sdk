import UIKit
import XCTest
import MemexSwiftSDK

class UserTests: BaseTestCase {
  
  func testUserCreation() {
    let expectation1 = expectation(description: "default")
    self.prepareSDK { (memex) in
      let credentials = Credentials(identifier: UUID().uuidString, secret: UUID().uuidString)
      let user = User()
      user.email = credentials.identifier
      user.password = credentials.secret
      user.fullname = "Bob Tester"
      memex.createUser(user: user, onboardingToken: nil, completion: { (newUser, error) in
        XCTAssertNil(error, "request failed")
        XCTAssertNotNil(newUser?.ID, "missing ID")
        XCTAssertNotNil(newUser?.createdAt, "missing created at")
        XCTAssertNotNil(newUser?.updatedAt, "missing updated at")
        XCTAssertNil(newUser?.password, "present password")
        XCTAssertNil(newUser?.avatar, "present avatar")
        XCTAssertNotNil(newUser?.originSpaceMUID, "missing originSpaceMUID")
        XCTAssertEqual(newUser?.email, credentials.identifier, "wrong email")
        XCTAssertEqual(newUser?.fullname, user.fullname, "wrong fullname")
        XCTAssertTrue(newUser?.hasPassword == true, "wrong hasPassword value")
        XCTAssertTrue(newUser?.advanced == false, "wrong advanced value")
        expectation1.fulfill()
      })
    }
    waitForExpectations(timeout: 10, handler: nil)
  }
  
  func testGetUser() {
    let expectation1 = expectation(description: "default")
    self.prepareSDK { (memex) in
      let credentials = Credentials(identifier: UUID().uuidString, secret: UUID().uuidString)
      let user = User()
      user.email = credentials.identifier
      user.password = credentials.secret
      user.fullname = "Bob Tester"
      memex.createUser(user: user, onboardingToken: nil, completion: { (newUser, error) in
        XCTAssertNil(error, "request failed")
        XCTAssertNotNil(newUser?.ID, "missing ID")
        memex.loginUserWithUserCredentials(credentials: credentials, completion: { (error) in
          XCTAssertNil(error, "request failed")
          memex.getUser(userID: User.Constants.myselfUserID, completion: { (getUser, error) in
            XCTAssertNotNil(getUser?.createdAt, "missing created at")
            XCTAssertNotNil(getUser?.updatedAt, "missing updated at")
            XCTAssertNil(getUser?.password, "present password")
            XCTAssertNil(getUser?.avatar, "present avatar")
            XCTAssertNotNil(getUser?.originSpaceMUID, "missing originSpaceMUID")
            XCTAssertEqual(getUser?.email, credentials.identifier, "wrong email")
            XCTAssertEqual(getUser?.fullname, user.fullname, "wrong fullname")
            XCTAssertTrue(getUser?.hasPassword == true, "wrong hasPassword value")
            XCTAssertTrue(getUser?.advanced == false, "wrong advanced value")
            expectation1.fulfill()
          })
        })
      })
    }
    waitForExpectations(timeout: 10, handler: nil)
  }
  
  
  func testUpdateUser() {
    let expectation1 = expectation(description: "default")
    self.prepareSDK { (memex) in
      let credentials = Credentials(identifier: UUID().uuidString, secret: UUID().uuidString)
      let user = User()
      user.email = credentials.identifier
      user.password = credentials.secret
      user.fullname = "Bob Tester"
      memex.createUser(user: user, onboardingToken: nil, completion: { (newUser, error) in
        XCTAssertNil(error, "request failed")
        XCTAssertNotNil(newUser?.ID, "missing ID")
        memex.loginUserWithUserCredentials(credentials: credentials, completion: { (error) in
          XCTAssertNil(error, "request failed")
          newUser?.email = UUID().uuidString
          newUser?.fullname = UUID().uuidString
          memex.updateUser(user: newUser!, completion: { (updatedUser, error) in
            XCTAssertNil(error, "request failed")
            XCTAssertEqual(updatedUser?.email, newUser?.email, "wrong email")
            XCTAssertEqual(updatedUser?.fullname, newUser?.fullname, "wrong fullname")
            expectation1.fulfill()
          })
        })
      })
    }
    waitForExpectations(timeout: 10, handler: nil)
  }
  
  func testSetPasswordUser() {
    let expectation1 = expectation(description: "default")
    self.prepareSDK { (memex) in
      let onboardingToken = UUID().uuidString
      let user = User()
      memex.createUser(user: user, onboardingToken: onboardingToken, completion: { (newUser, error) in
        XCTAssertNil(error, "request failed")
        XCTAssertTrue(newUser?.hasPassword == false, "has password after creation")
        memex.loginUserWithOnboardingToken(token: onboardingToken, completion: { (error) in
          XCTAssertNil(error, "request failed")
          memex.setUserPassword(oldPassword: nil, newPassword: "xxx", completion: { (error) in
            XCTAssertNil(error, "request failed")
            memex.getUser(userID: nil, completion: { (updatedUser, error) in
              XCTAssertNil(error, "request failed")
              XCTAssertTrue(updatedUser?.hasPassword == true, "has password after creation")
              expectation1.fulfill()
            })
          })
        })
      })
    }
    waitForExpectations(timeout: 10, handler: nil)
  }
  
  func testChangePasswordUser() {
    let expectation1 = expectation(description: "default")
    self.prepareSDK { (memex) in
      let credentials = Credentials(identifier: UUID().uuidString, secret: UUID().uuidString)
      let user = User()
      user.email = credentials.identifier
      user.password = credentials.secret
      memex.createUser(user: user, onboardingToken: nil, completion: { (newUser, error) in
        XCTAssertNil(error, "request failed")
        memex.loginUserWithUserCredentials(credentials: credentials, completion: { (error) in
          XCTAssertNil(error, "request failed")
          let newCredentials = Credentials(identifier: credentials.identifier, secret: UUID().uuidString)
          memex.setUserPassword(oldPassword: credentials.secret, newPassword: newCredentials.secret, completion: { (error) in
            memex.logout(completion: { (error) in
              XCTAssertNil(error, "request failed")
              memex.loginUserWithUserCredentials(credentials: newCredentials, completion: { (error) in
                XCTAssertNil(error, "request failed")
                expectation1.fulfill()
              })
            })
          })
        })
      })
    }
    waitForExpectations(timeout: 10, handler: nil)
  }
  
}
