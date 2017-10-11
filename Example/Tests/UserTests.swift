import UIKit
import XCTest
import MemexSwiftSDK

class UserTests: BaseTestCase {
  
  func testUserCreation() {
    let expectation1 = expectation(description: "default")
    self.prepareSDK { (memex, myself) in
      let credentials = Credentials(identifier: self.mockEmail(), secret: self.mockPassword())
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
        expectation1.fulfill()
      })
    }
    waitForExpectations(timeout: Constants.timeout, handler: nil)
  }
  
  func testGetUser() {
    let expectation1 = expectation(description: "default")
    self.prepareSDK { (memex, myself) in
      let credentials = Credentials(identifier: self.mockEmail(), secret: self.mockPassword())
      let user = User()
      user.email = credentials.identifier
      user.password = credentials.secret
      user.fullname = "Bob Tester"
      memex.createUser(user: user, onboardingToken: nil, completion: { (newUser, error) in
        XCTAssertNil(error, "request failed")
        XCTAssertNotNil(newUser?.ID, "missing ID")
        memex.loginUserWithUserCredentials(credentials: credentials, completion: { (retryToken, error) in
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
            expectation1.fulfill()
          })
        })
      })
    }
    waitForExpectations(timeout: Constants.timeout, handler: nil)
  }
  
  
  func testUpdateUser() {
    let expectation1 = expectation(description: "default")
    self.prepareSDK { (memex, myself) in
      let credentials = Credentials(identifier: self.mockEmail(), secret: self.mockPassword())
      let user = User()
      user.email = credentials.identifier
      user.password = credentials.secret
      user.fullname = "Bob Tester"
      memex.createUser(user: user, onboardingToken: nil, completion: { (newUser, error) in
        XCTAssertNil(error, "request failed")
        XCTAssertNotNil(newUser?.ID, "missing ID")
        memex.loginUserWithUserCredentials(credentials: credentials, completion: { (retryToken, error) in
          XCTAssertNil(error, "request failed")
          newUser?.email = self.mockEmail()
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
    waitForExpectations(timeout: Constants.timeout, handler: nil)
  }
  
  func testSetPasswordUser() {
    let expectation1 = expectation(description: "default")
    self.prepareSDK { (memex, myself) in
      let onboardingToken = UUID().uuidString
      let user = User()
      memex.createUser(user: user, onboardingToken: onboardingToken, completion: { (newUser, error) in
        XCTAssertNil(error, "request failed")
        XCTAssertTrue(newUser?.hasPassword == false, "has password after creation")
        memex.loginUserWithOnboardingToken(token: onboardingToken, completion: { (retryToken, error) in
          XCTAssertNil(error, "request failed")
          memex.setUserPassword(oldPassword: nil, newPassword: self.mockPassword(), completion: { (error) in
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
    waitForExpectations(timeout: Constants.timeout, handler: nil)
  }
  
  func testChangePasswordUser() {
    let expectation1 = expectation(description: "default")
    self.prepareSDK { (memex, myself) in
      let credentials = Credentials(identifier: self.mockEmail(), secret: self.mockPassword())
      let user = User()
      user.email = credentials.identifier
      user.password = credentials.secret
      memex.createUser(user: user, onboardingToken: nil, completion: { (newUser, error) in
        XCTAssertNil(error, "request failed")
        memex.loginUserWithUserCredentials(credentials: credentials, completion: { (retryToken, error) in
          XCTAssertNil(error, "request failed")
          let newCredentials = Credentials(identifier: credentials.identifier, secret: self.mockPassword())
          memex.setUserPassword(oldPassword: credentials.secret, newPassword: newCredentials.secret, completion: { (error) in
            memex.logout(completion: { (error) in
              XCTAssertNil(error, "request failed")
              memex.loginUserWithUserCredentials(credentials: newCredentials, completion: { (retryToken, error) in
                XCTAssertNil(error, "request failed")
                expectation1.fulfill()
              })
            })
          })
        })
      })
    }
    waitForExpectations(timeout: Constants.timeout, handler: nil)
  }
  
  func testResetPassword() {
    let expectation1 = expectation(description: "default")
    self.prepareSDK { (memex, myself) in
      let onboardingToken = UUID().uuidString
      let user = User()
      let email = self.mockEmail()
      user.email = email
      memex.createUser(user: user, onboardingToken: onboardingToken, completion: { (newUser, error) in
        memex.requestPasswordReset(email: email, completion: { (error) in
          XCTAssertNil(error, "request failed")
          memex.resetPassword(resetToken: "invalid", newPassword: self.mockPassword(), completion: { (error2) in
            XCTAssertNotNil(error2, "request not failed")
            expectation1.fulfill()
          })
        })
      })
    }
    waitForExpectations(timeout: Constants.timeout, handler: nil)
  }
  
  func testEmailVerification() {
    let expectation1 = expectation(description: "default")
    self.prepareSDK() { (memex, myself) in
      let onboardingToken = UUID().uuidString
      let user = User()
      let email = self.mockEmail()
      user.email = email
      memex.createUser(user: user, onboardingToken: onboardingToken, completion: { (newUser, error) in
        memex.loginUserWithOnboardingToken(token: onboardingToken, completion: { (retryToken, error) in
          memex.requestContactVerification(type: .email, completion: { (error) in
            XCTAssertNil(error, "request failed")
            memex.verifyContact(type: .email, verificationToken: "invalid", completion: { (error2) in
              XCTAssertNotNil(error2, "request not failed")
              expectation1.fulfill()
            })
          })
        })
      })
    }
    waitForExpectations(timeout: Constants.timeout, handler: nil)
  }
  
  func testEmailVerificationWithoutLogin() {
    let expectation1 = expectation(description: "default")
    self.prepareSDK { (memex, myself) in
      let onboardingToken = UUID().uuidString
      let user = User()
      let email = self.mockEmail()
      user.email = email
      memex.createUser(user: user, onboardingToken: onboardingToken, completion: { (newUser, error) in
        memex.requestContactVerification(type: .email, completion: { (error) in
          XCTAssertNotNil(error, "error is nil")
          expectation1.fulfill()
        })
      })
    }
    waitForExpectations(timeout: Constants.timeout, handler: nil)
  }
  
}
