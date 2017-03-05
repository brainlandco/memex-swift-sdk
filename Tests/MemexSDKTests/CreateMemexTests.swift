//
//  CreateMemex.swift
//  MemexSDK
//
//  Created by Adam Zdara on 05/03/2017.
//
//

@testable import MemexSDK
import XCTest

class CreateMemexTests: XCTestCase {
  
  func testGetRequestStatusCode() {
    let memex = Memex(key: "some", secret: "key", environment: .sandbox)
    print(memex)
  }
  
}
