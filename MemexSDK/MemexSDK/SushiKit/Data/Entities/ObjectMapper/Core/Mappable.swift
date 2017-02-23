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

public protocol SUMappable {
  init?(_ map: SUMap)
  mutating func mapping(map: SUMap)
}

public protocol SUMappableCluster: SUMappable {
  static func objectForMapping(map: SUMap) -> SUMappable?
}

public extension SUMappable {
  
  /// Initializes object from a JSON String
  public init?(jsonString: String) {
    if let obj: Self = SUMapper().map(jsonString) {
      self = obj
    } else {
      return nil
    }
  }
  
  /// Initializes object from a JSON Dictionary
  public init?(JSON: [String : AnyObject]) {
    if let obj: Self = SUMapper().map(JSON) {
      self = obj
    } else {
      return nil
    }
  }
  
  /// Returns the JSON Dictionary for the object
  public func toJSON() -> [String: AnyObject] {
    return SUMapper().toJSON(self)
  }
  
  /// Returns the JSON String for the object
  public func toJSONString(prettyPrint: Bool = false) -> String? {
    return SUMapper().toJSONString(self, prettyPrint: prettyPrint)
  }
}

public extension Array where Element: SUMappable {
  
  /// Initialize Array from a JSON String
  public init?(jsonString: String) {
    if let obj: [Element] = SUMapper().mapArray(jsonString) {
      self = obj
    } else {
      return nil
    }
  }
  
  /// Initialize Array from a JSON Array
  public init?(jsonArray: [[String : AnyObject]]) {
    if let obj: [Element] = SUMapper().mapArray(jsonArray) {
      self = obj
    } else {
      return nil
    }
  }
  
  /// Returns the JSON Array
  public func toJSON() -> [[String : AnyObject]] {
    return SUMapper().toJSONArray(self)
  }
  
  /// Returns the JSON String for the object
  public func toJSONString(prettyPrint: Bool = false) -> String? {
    return SUMapper().toJSONString(self, prettyPrint: prettyPrint)
  }
}

public extension Set where Element: SUMappable {
  
  /// Initializes a set from a JSON String
  public init?(jsonString: String) {
    if let obj: Set<Element> = SUMapper().mapSet(jsonString) {
      self = obj
    } else {
      return nil
    }
  }
  
  /// Initializes a set from JSON
  public init?(jsonArray: [[String : AnyObject]]) {
    if let obj: Set<Element> = SUMapper().mapSet(jsonArray) {
      self = obj
    } else {
      return nil
    }
  }
  
  /// Returns the JSON Set
  public func toJSON() -> [[String : AnyObject]] {
    return SUMapper().toJSONSet(self)
  }
  
  /// Returns the JSON String for the object
  public func toJSONString(prettyPrint: Bool = false) -> String? {
    return SUMapper().toJSONString(self, prettyPrint: prettyPrint)
  }
}
