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

public class SUISO8601DateTransform: SUTransformType {
  
  public typealias Object = NSDate
  public typealias JSON = String

  static let standardDateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    return formatter
  }()
  static let decimalDateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    return formatter
  }()
  
  public init() {
  }
  
  public func transformFromJSON(value: AnyObject?) -> NSDate? {
    if let dateString = value as? String {
      if let date = SUISO8601DateTransform.decimalDateFormatter.dateFromString(dateString) {
        return date
      } else {
        return SUISO8601DateTransform.standardDateFormatter.dateFromString(dateString)
      }
    }
    return nil
  }
  
  public func transformToJSON(value: NSDate?) -> String? {
    if let date = value {
      return SUISO8601DateTransform.decimalDateFormatter.stringFromDate(date)
    }
    return nil
  }
}
