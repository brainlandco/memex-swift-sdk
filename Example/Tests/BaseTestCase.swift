import UIKit
import XCTest
import MemexSwiftSDK

class BaseTestCase: XCTestCase {
  
  var memex: Memex!
  
  struct Constants {
    static let appToken = "c82070e09366bc37f7da0a275895955a7ec8d3c0"
  }
  
  func prepareSDK(completion: @escaping (_ memex: Memex) -> ()) {
    self.memex = Memex(appToken: Constants.appToken, environment: .staging, verbose: true)
    memex.prepare { error in
      XCTAssertNil(error, "nonnil error")
      self.memex.logout { error in
        XCTAssertNil(error, "nonnil error")
        completion(self.memex)
      }
    }
  }
  
}
