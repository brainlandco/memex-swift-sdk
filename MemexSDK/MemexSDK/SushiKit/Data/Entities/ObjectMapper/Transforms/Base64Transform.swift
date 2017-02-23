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

public class SUBase64Transform: SUTransformType {
  
  public typealias Object = NSData
  public typealias JSON = String
  
  public init() {}
  
  public func transformFromJSON(value: AnyObject?) -> NSData? {
    if let string = value as? String {
      let data = NSData(base64EncodedString: string, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
      return data
    }
    return nil
  }
  
  public func transformToJSON(value: NSData?) -> String? {
    if let data = value {
      return data.base64EncodedStringWithOptions([])
    }
    return nil
  }
}
