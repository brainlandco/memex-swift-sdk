import UIKit
import XCTest
import MemexSwiftSDK

class SpacesTests: BaseTestCase {
  
  func testCreation() {
    let expectation1 = expectation(description: "default")
    self.prepareSDK(authorize: true) { (memex, myself) in
      let space = Space()
      space.MUID = UUID().uuidString
      space.spaceType = .collection
      
      let media = Media()
      media.MUID = UUID().uuidString
      media.mediaType = .source
      media.embededData = "text".data(using: .utf8)
      media.dataState = .dataValid
      space.representations = [media]
      memex.createSpace(space: space, process: .no, autodump: false, completion: { (newSpace, error) in
        XCTAssertNil(error, "request failed")
        XCTAssertNotNil(newSpace?.MUID, "missing ID")
        XCTAssertNotNil(newSpace?.createdAt, "missing created at")
        XCTAssertNotNil(newSpace?.updatedAt, "missing updated at")
        XCTAssertNil(newSpace?.visitedAt, "non nil visitedAt")
        XCTAssertTrue(newSpace?.spaceType == space.spaceType, "wrong data")
        XCTAssertTrue(newSpace?.MUID == space.MUID, "wrong data state")
        XCTAssertTrue(newSpace?.state == .visible, "wrong visibility state")
        XCTAssertNotNil(newSpace?.ownerID, "missing owner")
        XCTAssertTrue(newSpace?.ownerID == myself?.ID, "wrong owner")
        XCTAssertTrue(newSpace?.unread == false, "wrong unread")
        let representation = newSpace?.representations![0]
        XCTAssertTrue(representation!.MUID == media.MUID, "wrong representation MUID")
        expectation1.fulfill()
      })
    }
    waitForExpectations(timeout: Constants.timeout, handler: nil)
  }
  
  
}
