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

public class SUColorTransform: SUTransformType {
  
  public typealias Object = UIColor
  public typealias JSON = String
  
  public init() {}
  
  public func transformFromJSON(value: AnyObject?) -> UIColor? {
    if let string = value as? String {
      return UIColor.colorFromJSColorString(string)
    }
    return nil
  }
  
  public func transformToJSON(value: UIColor?) -> String? {
    if let color = value {
      return color.JSColorString()
    }
    return nil
  }
}
