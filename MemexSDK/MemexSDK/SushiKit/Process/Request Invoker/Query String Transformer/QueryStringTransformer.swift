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

class QueryStringTransformer {
  
  init() {
  }
  
  func queryStringFromParameters(parameters: [String: AnyObject]!, error: NSErrorPointer) -> String? {
    if parameters == nil {
      return nil
    }
    let queryItems = self.queryItemsFromObject(parameters, key: nil)
    return NSURL.queryStringFromQueryItems(queryItems, encoding: NSASCIIStringEncoding)
  }
  
  func parametersFromQueryString(queryString: String?, error: NSErrorPointer) -> [String: AnyObject]? {
    if queryString == nil {
      return nil
    }
    let queryItems = NSURL.queryItemsFromQueryString(queryString!, encoding: NSASCIIStringEncoding)
    var parameters = [String: AnyObject]()
    for queryItem in queryItems {
      let key = queryItem.name as! String
      parameters[key] = queryItem.value
    }
    return parameters
  }
  
  private func queryItemsFromObject(object: AnyObject!, key: AnyObject!) -> [ATURLQueryItem] {
    var queryItems = [ATURLQueryItem]()
    if object is [String: AnyObject] {
      let dictionary = object as! [String: AnyObject]
      for nestedKey in dictionary.keys {
        let nestedValue: AnyObject! = dictionary[nestedKey as String]
        let nextLevelKey = key != nil ? "\(key)[\(nestedKey)]" : nestedKey
        queryItems += self.queryItemsFromObject(nestedValue, key:nextLevelKey)
      }
    } else if object is [AnyObject] {
      let array = object as! [AnyObject]
      for nestedValue in array {
        queryItems += self.queryItemsFromObject(nestedValue, key:"\(key)[]")
      }
    } else {
      queryItems.append(ATURLQueryItem(name:key, value:object))
    }
    return queryItems
  }
  
}
