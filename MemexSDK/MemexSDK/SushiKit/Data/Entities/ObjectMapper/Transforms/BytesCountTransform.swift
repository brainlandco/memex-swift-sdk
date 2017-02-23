/**
 *
 * Copyright (c) 2015, Adam Zdara.
 * Created by: Adam Zdara on 16.12.2015
 *
 * All rights reserved. This source code can be used only for purposes specified
 * by the given license contract signed by the rightful deputy of Adam Zdara.
 * This source code can be used only by the owner of the license.
 *
 * Any disputes arising in respect of this agreement (license) shall be brought
 * before the Municipal Court of Prague.
 *
 */

import Foundation
import UIKit

public class SUBytesCountTransform: SUTransformType {
  
  public typealias Object = Int64
  public typealias JSON = NSNumber
  
  public init() {
  }
  
  public func transformFromJSON(value: AnyObject?) -> Int64? {
    if let number = value as? NSNumber {
      return number.longLongValue
    } else {
      return nil
    }
  }
  
  public func transformToJSON(value: Int64?) -> NSNumber? {
    if let number = value {
      return NSNumber(longLong: number)
    }
    return nil
  }
}
