import UIKit
import XCTest
import MemexSwiftSDK

class LinksTests: BaseTestCase {
  
  func testCreation() {
    let expectation1 = expectation(description: "default")
    self.prepareSDK(authorize: true) { (memex, myself) in
      let space = Space()
      space.MUID = UUID().uuidString
      memex.createSpace(space: space, process: .no, autodump: false, completion: { (newSpace, error) in
        XCTAssertNil(error, "request failed")
        
        let link = Link()
        link.originSpaceMUID = newSpace?.MUID
        link.targetSpaceMUID = newSpace?.MUID
        memex.createLink(link: link, completion: { (newLink, error) in
          XCTAssertNil(error, "request failed")
          XCTAssertNotNil(newSpace?.MUID, "missing ID")
          XCTAssertNotNil(newSpace?.createdAt, "missing created at")
          XCTAssertNotNil(newSpace?.updatedAt, "missing updated at")
          XCTAssertTrue(newSpace?.MUID == space.MUID, "wrong MUID")
          XCTAssertTrue(newSpace?.state == .visible, "wrong visibility state")
          XCTAssertNotNil(newSpace?.ownerID, "missing owner")
          XCTAssertTrue(newSpace?.ownerID == myself?.ID, "wrong owner")
          XCTAssertTrue(newLink?.originSpaceMUID == newSpace?.MUID, "wrong origin space")
          XCTAssertTrue(newLink?.targetSpaceMUID == newSpace?.MUID, "wrong target space")
          expectation1.fulfill()
        })
        
      })
    }
    waitForExpectations(timeout: Constants.timeout, handler: nil)
  }
  
  func testGetSpaceLinks() {
    let expectation1 = expectation(description: "default")
    self.prepareSDK(authorize: true) { (memex, myself) in
      let space = Space()
      space.MUID = UUID().uuidString
      memex.createSpace(space: space, process: .no, autodump: false, completion: { (newSpace, error) in
        XCTAssertNil(error, "request failed")
        
        let link = Link()
        link.MUID = UUID().uuidString
        link.originSpaceMUID = newSpace?.MUID
        link.targetSpaceMUID = newSpace?.MUID
        memex.createLink(link: link, completion: { (newLink, error) in
          XCTAssertNil(error, "request failed")
          memex.getSpaceLinks(muid: space.MUID!, completion: { (links, error) in
            XCTAssertNil(error, "request failed")
            XCTAssertTrue(links != nil, "nil links and no error")
            XCTAssertTrue(links?.count == 1, "wrong number of links")
            let getLink = links?.first
            XCTAssertTrue(getLink?.MUID == link.MUID, "wrong number of links")
            expectation1.fulfill()
          })
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
      memex.createSpace(space: space, process: .no, autodump: false, completion: { (newSpace, error) in
        XCTAssertNil(error, "request failed")
        
        let link = Link()
        link.MUID = UUID().uuidString
        link.originSpaceMUID = newSpace?.MUID
        link.targetSpaceMUID = newSpace?.MUID
      
        memex.pushLinks(items: [link], completion: { (oldModelVersion, newModelVersion, error) in
          XCTAssertNil(error, "request failed")
          XCTAssertTrue(oldModelVersion == 1, "wrong old model version")
          XCTAssertTrue(newModelVersion == 2, "wrong new model version")
          memex.pullLinks(lastModelVersion: newModelVersion, offset: 0, completion: { (returnedLinks, modelVersion, total, more, nextOffset, error) in
            XCTAssertNil(error, "request failed")
            XCTAssertTrue(returnedLinks!.count == 0, "wrong number of links")
            XCTAssertTrue(total == 0, "wrong number of total")
            XCTAssertTrue(nextOffset == nil, "wrong next offset")
            XCTAssertTrue(more == false, "wrong number of total")
            XCTAssertTrue(modelVersion == newModelVersion, "wrong old model version")
            
            memex.pullLinks(lastModelVersion: nil, offset: 0, completion: { (returnedLinks, modelVersion, total, more, nextOffset, error) in
              XCTAssertNil(error, "request failed")
              XCTAssertTrue(returnedLinks!.count >= 1, "wrong number of spaces")
              XCTAssertTrue(returnedLinks!.filter({ $0.MUID! == link.MUID!}).count >= 1, "new link not found")
              XCTAssertTrue(total! >= 1, "wrong number of total")
              XCTAssertTrue(nextOffset == nil, "wrong next offset")
              XCTAssertTrue(more == false, "wrong number of total")
              XCTAssertTrue(modelVersion == newModelVersion, "wrong old model version")
              expectation1.fulfill()
            })
            
          })
          
        })
      })
      
    }
    waitForExpectations(timeout: Constants.timeout, handler: nil)
  }

  
}
