//
//  CreateMemex.swift
//  MemexSDK
//
//  Created by Adam Zdara on 05/03/2017.
//
//

@testable import MemexSDK
import XCTest

class BasicTests: XCTestCase {
  
  func testGetRequestStatusCode() {
    let memex = Memex(key: "XsL3i4Kleu2yoqfahMZMBWLCDwH3chKwPZpyDb5I",
                      secret: "0wB9WKyrTvnxB3VwuMNditWfpDM6amE1803V4FHJ",
                      environment: .staging)
    print(memex)
  }
  
}
