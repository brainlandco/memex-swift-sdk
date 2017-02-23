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

public class SUDecimalNumberTransform: SUTransformType {
  
  public typealias Object = NSDecimalNumber
  public typealias JSON = AnyObject
  
  public init() {}
  
  public func transformFromJSON(value: AnyObject?) -> NSDecimalNumber? {
    if let value = value {
      let string = "\(value)"
      return NSDecimalNumber(string: string)
    }
    return nil
  }
  
  public func transformToJSON(value: NSDecimalNumber?) -> AnyObject? {
    if let value = value {
      return value.stringValue
    }
    return nil
  }
}
