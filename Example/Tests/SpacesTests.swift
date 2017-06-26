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
      space.caption = "caption"
      space.color = Color(red: 0, green: 1, blue: 0)
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
        XCTAssertTrue(newSpace?.caption == space.caption, "wrong caption")
        XCTAssertTrue(newSpace?.MUID == space.MUID, "wrong MUID")
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
  
  func testGet() {
    let expectation1 = expectation(description: "default")
    self.prepareSDK(authorize: true) { (memex, myself) in
      let space = Space()
      space.MUID = UUID().uuidString
      space.spaceType = .collection
      memex.createSpace(space: space, process: .no, autodump: false, completion: { (newSpace, error) in
        XCTAssertNil(error, "request failed")
        memex.getSpace(muid: newSpace!.MUID!, completion: { (getSpace, error) in
          XCTAssertNil(error, "request failed")
          XCTAssertTrue(getSpace?.MUID == space.MUID, "wrong MUID")
        })
        expectation1.fulfill()
      })
    }
    waitForExpectations(timeout: Constants.timeout, handler: nil)
  }
  
  func testLogVisits() {
    let expectation1 = expectation(description: "default")
    self.prepareSDK(authorize: true) { (memex, myself) in
      let space = Space()
      space.MUID = UUID().uuidString
      space.spaceType = .collection
      memex.createSpace(space: space, process: .no, autodump: false, completion: { (newSpace, error) in
        XCTAssertNil(error, "request failed")
        XCTAssertNil(newSpace?.visitedAt, "request failed")
        let visit = SpaceVisit()
        visit.spaceMUID = newSpace?.MUID
        visit.visitedAt = Date()
        memex.logSpaceVisits(visits: [visit], completion: { (error) in
          XCTAssertNil(error, "request failed")
          memex.getSpace(muid: newSpace!.MUID!, completion: { (getSpace, error) in
            XCTAssertNil(error, "request failed")
            XCTAssertNotNil(getSpace?.visitedAt, "missing visited at")
            let delta = visit.visitedAt!.timeIntervalSince(getSpace!.visitedAt!)
            XCTAssertTrue(abs(delta) < 2, "wrong MUID")
            expectation1.fulfill()
          })
        })
      })
    }
    waitForExpectations(timeout: Constants.timeout, handler: nil)
  }
  
  func testGetAbstract() {
    let expectation1 = expectation(description: "default")
    self.prepareSDK(authorize: true) { (memex, myself) in
      let space = Space()
      space.MUID = UUID().uuidString
      space.spaceType = .collection
      memex.createSpace(space: space, process: .no, autodump: false, completion: { (newSpace, error) in
        XCTAssertNil(error, "request failed")
        memex.getSpacesAbstract(muids: [newSpace!.MUID!], completion: { (caption, error) in
          XCTAssertNil(error, "request failed")
          expectation1.fulfill()
        })
      })
    }
    waitForExpectations(timeout: Constants.timeout, handler: nil)
  }
  
  
  func testPushPull() {
    let expectation1 = expectation(description: "default")
    self.prepareSDK(authorize: true) { (memex, myself) in
      let space = Space()
      space.MUID = UUID().uuidString
      memex.pushSpaces(items: [space], completion: { (oldModelVersion, newModelVersion, error) in
        XCTAssertNil(error, "request failed")
        XCTAssertTrue(oldModelVersion == 0, "wrong old model version")
        XCTAssertTrue(newModelVersion == 1, "wrong new model version")
        memex.pullSpaces(lastModelVersion: newModelVersion, offset: 0, completion: { (returnedSpaces, modelVersion, total, more, nextOffset, error) in
          XCTAssertNil(error, "request failed")
          XCTAssertTrue(returnedSpaces!.count == 0, "wrong number of spaces")
          XCTAssertTrue(total == 0, "wrong number of total")
          XCTAssertTrue(nextOffset == nil, "wrong next offset")
          XCTAssertTrue(more == false, "wrong number of total")
          XCTAssertTrue(modelVersion == newModelVersion, "wrong old model version")
          
          memex.pullSpaces(lastModelVersion: nil, offset: 0, completion: { (returnedSpaces, modelVersion, total, more, nextOffset, error) in
            XCTAssertNil(error, "request failed")
            XCTAssertTrue(returnedSpaces!.count >= 1, "wrong number of spaces")
            XCTAssertTrue(returnedSpaces!.filter({ $0.MUID! == space.MUID!}).count >= 1, "new space not found")
            XCTAssertTrue(total! >= 1, "wrong number of total")
            XCTAssertTrue(nextOffset == nil, "wrong next offset")
            XCTAssertTrue(more == false, "wrong number of total")
            XCTAssertTrue(modelVersion == newModelVersion, "wrong old model version")
            expectation1.fulfill()
          })
          
        })
        
      })
    }
    waitForExpectations(timeout: Constants.timeout, handler: nil)
    
  }
  
  
}
