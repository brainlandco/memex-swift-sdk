
import Foundation


public extension URL {
  
  static func queryStringFromQueryItems(items: [URLQueryItem], encoding: String.Encoding) -> String {
    let components = items.map { item in
      "\(item.name)=\(item.value!)"
    }
    return components.joined(separator: "&")
  }
  
  static func queryItemsFromQueryString(string: String, encoding: String.Encoding) -> [URLQueryItem] {
    let components = string.components(separatedBy: "&")
    return components.map({ item in
      let parts = string.components(separatedBy: "=")
      return URLQueryItem(name: parts.first!, value: parts.last!)
    })
  }
  
}

class QueryStringTransformer {
  
  init() {
  }
  
  func queryStringFromParameters(parameters: [String: Any]!, error: NSErrorPointer) -> String? {
    if parameters == nil {
      return nil
    }
    let queryItems = self.queryItemsFromObject(object: parameters, key: nil)
    return URL.queryStringFromQueryItems(items: queryItems, encoding: String.Encoding.ascii)
  }
  
  func parametersFromQueryString(queryString: String?, error: NSErrorPointer) -> [String: Any]? {
    if queryString == nil {
      return nil
    }
    let queryItems = URL.queryItemsFromQueryString(string: queryString!, encoding: String.Encoding.ascii)
    var parameters = [String: Any]()
    for queryItem in queryItems {
      let key = queryItem.name
      parameters[key] = queryItem.value
    }
    return parameters
  }
  
  private func queryItemsFromObject(object: Any!, key: Any!) -> [URLQueryItem] {
    var queryItems = [URLQueryItem]()
    if object is [String: Any] {
      let dictionary = object as! [String: Any]
      for nestedKey in dictionary.keys {
        let nestedValue = dictionary[nestedKey as String]
        let nextLevelKey = key != nil ? "\(key)[\(nestedKey)]" : nestedKey
        queryItems += self.queryItemsFromObject(object: nestedValue, key:nextLevelKey as AnyObject!)
      }
    } else if object is [AnyObject] {
      let array = object as! [AnyObject]
      for nestedValue in array {
        queryItems += self.queryItemsFromObject(object: nestedValue, key:"\(key)[]" as AnyObject!)
      }
    } else {
      queryItems.append(URLQueryItem(name:key as! String, value:object as! String?))
    }
    return queryItems
  }
  
}
