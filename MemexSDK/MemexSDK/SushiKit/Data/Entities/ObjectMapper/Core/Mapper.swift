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

public enum SUMappingType {
  case FromJSON
  case ToJSON
}

/// The Mapper class provides methods for converting Model objects to JSON and methods for converting JSON to Model objects
public final class SUMapper<N: SUMappable> {
  
  public init() {}
  
  // MARK: Mapping functions that map to an existing object toObject
  
  /// Maps a JSON object to an existing Mappable object if it is a JSON dictionary, or returns the passed object as is
  public func map(JSON: AnyObject?, toObject object: N) -> N {
    if let JSON = JSON as? [String : AnyObject] {
      return map(JSON, toObject: object)
    }
    
    return object
  }
  
  /// Map a JSON string onto an existing object
  public func map(jsonString: String, toObject object: N) -> N {
    if let JSON = SUMapper.parsejsonDictionary(jsonString) {
      return map(JSON, toObject: object)
    }
    return object
  }
  
  /// Maps a JSON dictionary to an existing object that conforms to Mappable.
  /// Usefull for those pesky objects that have crappy designated initializers like NSManagedObject
  public func map(jsonDictionary: [String : AnyObject], toObject object: N) -> N {
    var mutableObject = object
    let map = SUMap(mappingType: .FromJSON, jsonDictionary: jsonDictionary, toObject: true)
    mutableObject.mapping(map)
    return mutableObject
  }
  
  //MARK: Mapping functions that create an object
  
  /// Map an optional JSON string to an object that conforms to Mappable
  public func map(jsonString: String?) -> N? {
    if let jsonString = jsonString {
      return map(jsonString)
    }
    
    return nil
  }
  
  /// Map a JSON string to an object that conforms to Mappable
  public func map(jsonString: String) -> N? {
    if let JSON = SUMapper.parsejsonDictionary(jsonString) {
      return map(JSON)
    }
    
    return nil
  }
  
  /// Map a JSON NSString to an object that conforms to Mappable
  public func map(jsonString: NSString) -> N? {
    return map(jsonString as String)
  }
  
  /// Maps a JSON object to a Mappable object if it is a JSON dictionary or NSString, or returns nil.
  public func map(JSON: AnyObject?) -> N? {
    if let JSON = JSON as? [String : AnyObject] {
      return map(JSON)
    }
    
    return nil
  }
  
  /// Maps a JSON dictionary to an object that conforms to Mappable
  public func map(jsonDictionary: [String : AnyObject]) -> N? {
    let map = SUMap(mappingType: .FromJSON, jsonDictionary: jsonDictionary)
    
    // check if N is of type MappableCluster
    if let klass = N.self as? SUMappableCluster.Type {
      if var object = klass.objectForMapping(map) as? N {
        object.mapping(map)
        return object
      }
    }
    
    if var object = N(map) {
      object.mapping(map)
      return object
    }
    return nil
  }
  
  // MARK: Mapping functions for Arrays and Dictionaries
  
  /// Maps a JSON array to an object that conforms to Mappable
  public func mapArray(jsonString: String) -> [N]? {
    let parsedJSON: AnyObject? = SUMapper.parsejsonString(jsonString)
    
    if let objectArray = mapArray(parsedJSON) {
      return objectArray
    }
    
    // failed to parse JSON into array form
    // try to parse it into a dictionary and then wrap it in an array
    if let object = map(parsedJSON) {
      return [object]
    }
    
    return nil
  }
  
  /// Maps a optional JSON String into an array of objects that conforms to Mappable
  public func mapArray(jsonString: String?) -> [N]? {
    if let jsonString = jsonString {
      return mapArray(jsonString)
    }
    
    return nil
  }
  
  /// Maps a JSON object to an array of Mappable objects if it is an array of JSON dictionary, or returns nil.
  public func mapArray(JSON: AnyObject?) -> [N]? {
    if let jsonArray = JSON as? [[String : AnyObject]] {
      return mapArray(jsonArray)
    }
    
    return nil
  }
  
  /// Maps an array of JSON dictionary to an array of Mappable objects
  public func mapArray(jsonArray: [[String : AnyObject]]) -> [N]? {
    // map every element in JSON array to type N
    let result = jsonArray.flatMap(map)
    return result
  }
  
  /// Maps a JSON object to a dictionary of Mappable objects if it is a JSON dictionary of dictionaries, or returns nil.
  public func mapDictionary(jsonString: String) -> [String : N]? {
    let parsedJSON: AnyObject? = SUMapper.parsejsonString(jsonString)
    return mapDictionary(parsedJSON)
  }
  
  /// Maps a JSON object to a dictionary of Mappable objects if it is a JSON dictionary of dictionaries, or returns nil.
  public func mapDictionary(JSON: AnyObject?) -> [String : N]? {
    if let jsonDictionary = JSON as? [String : [String : AnyObject]] {
      return mapDictionary(jsonDictionary)
    }
    
    return nil
  }
  
  /// Maps a JSON dictionary of dictionaries to a dictionary of Mappble objects
  public func mapDictionary(jsonDictionary: [String : [String : AnyObject]]) -> [String : N]? {
    // map every value in dictionary to type N
    let result = jsonDictionary.filterMap(map)
    if result.isEmpty == false {
      return result
    }
    
    return nil
  }
  
  /// Maps a JSON object to a dictionary of Mappable objects if it is a JSON dictionary of dictionaries, or returns nil.
  public func mapDictionary(JSON: AnyObject?, toDictionary dictionary: [String : N]) -> [String : N] {
    if let jsonDictionary = JSON as? [String : [String : AnyObject]] {
      return mapDictionary(jsonDictionary, toDictionary: dictionary)
    }
    
    return dictionary
  }
  
  /// Maps a JSON dictionary of dictionaries to an existing dictionary of Mappble objects
  public func mapDictionary(jsonDictionary: [String : [String : AnyObject]],
                            toDictionary dictionary: [String : N]) -> [String : N] {
    var mutableDictionary = dictionary
    for (key, value) in jsonDictionary {
      if let object = dictionary[key] {
        SUMapper().map(value, toObject: object)
      } else {
        mutableDictionary[key] = SUMapper().map(value)
      }
    }
    
    return mutableDictionary
  }
  
  /// Maps a JSON object to a dictionary of arrays of Mappable objects
  public func mapDictionaryOfArrays(JSON: AnyObject?) -> [String : [N]]? {
    if let jsonDictionary = JSON as? [String : [[String : AnyObject]]] {
      return mapDictionaryOfArrays(jsonDictionary)
    }
    
    return nil
  }
  
  ///Maps a JSON dictionary of arrays to a dictionary of arrays of Mappable objects
  public func mapDictionaryOfArrays(jsonDictionary: [String : [[String : AnyObject]]]) -> [String : [N]]? {
    // map every value in dictionary to type N
    let result = jsonDictionary.filterMap {
      mapArray($0)
    }
    
    if result.isEmpty == false {
      return result
    }
    
    return nil
  }
  
  /// Maps an 2 dimentional array of JSON dictionaries to a 2 dimentional array of Mappable objects
  public func mapArrayOfArrays(JSON: AnyObject?) -> [[N]]? {
    if let jsonArray = JSON as? [[[String : AnyObject]]] {
      var objectArray = [[N]]()
      for innerjsonArray in jsonArray {
        if let array = mapArray(innerjsonArray) {
          objectArray.append(array)
        }
      }
      
      if objectArray.isEmpty == false {
        return objectArray
      }
    }
    
    return nil
  }
  
  // MARK: Utility functions for converting strings to JSON objects
  
  /// Convert a JSON String into a Dictionary<String, AnyObject> using NSJSONSerialization
  public static func parsejsonDictionary(JSON: String) -> [String : AnyObject]? {
    let parsedJSON: AnyObject? = SUMapper.parsejsonString(JSON)
    return SUMapper.parsejsonDictionary(parsedJSON)
  }
  
  /// Convert a JSON Object into a Dictionary<String, AnyObject> using NSJSONSerialization
  public static func parsejsonDictionary(JSON: AnyObject?) -> [String : AnyObject]? {
    if let JSONDict = JSON as? [String : AnyObject] {
      return JSONDict
    }
    
    return nil
  }
  
  /// Convert a JSON String into an Object using NSJSONSerialization
  public static func parsejsonString(JSON: String) -> AnyObject? {
    let data = JSON.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
    if let data = data {
      let parsedJSON: AnyObject?
      do {
        parsedJSON = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
      } catch let error {
        print(error)
        parsedJSON = nil
      }
      return parsedJSON
    }
    
    return nil
  }
}

extension SUMapper {
  
  // MARK: Functions that create JSON from objects
  
  ///Maps an object that conforms to Mappable to a JSON dictionary <String : AnyObject>
  public func toJSON( object: N) -> [String : AnyObject] {
    var mutableObject = object
    let map = SUMap(mappingType: .ToJSON, jsonDictionary: [:])
    mutableObject.mapping(map)
    return map.jsonDictionary
  }
  
  ///Maps an array of Objects to an array of JSON dictionaries [[String : AnyObject]]
  public func toJSONArray(array: [N]) -> [[String : AnyObject]] {
    return array.map {
      // convert every element in array to JSON dictionary equivalent
      self.toJSON($0)
    }
  }
  
  ///Maps a dictionary of Objects that conform to Mappable to a JSON dictionary of dictionaries.
  public func tojsonDictionary(dictionary: [String : N]) -> [String : [String : AnyObject]] {
    return dictionary.map { k, v in
      // convert every value in dictionary to its JSON dictionary equivalent
      return (k, self.toJSON(v))
    }
  }
  
  ///Maps a dictionary of Objects that conform to Mappable to a JSON dictionary of dictionaries.
  public func tojsonDictionaryOfArrays(dictionary: [String : [N]]) -> [String : [[String : AnyObject]]] {
    return dictionary.map { k, v in
      // convert every value (array) in dictionary to its JSON dictionary equivalent
      return (k, self.toJSONArray(v))
    }
  }
  
  /// Maps an Object to a JSON string with option of pretty formatting
  public func toJSONString(object: N, prettyPrint: Bool = false) -> String? {
    let JSONDict = toJSON(object)
    
    return SUMapper.toJSONString(JSONDict, prettyPrint: prettyPrint)
  }
  
  /// Maps an array of Objects to a JSON string with option of pretty formatting
  public func toJSONString(array: [N], prettyPrint: Bool = false) -> String? {
    let JSONDict = toJSONArray(array)
    
    return SUMapper.toJSONString(JSONDict, prettyPrint: prettyPrint)
  }
  
  public static func toJSONString(jsonObject: AnyObject, prettyPrint: Bool) -> String? {
    if NSJSONSerialization.isValidJSONObject(jsonObject) {
      let JSONData: NSData?
      do {
        let options: NSJSONWritingOptions = prettyPrint ? .PrettyPrinted : []
        JSONData = try NSJSONSerialization.dataWithJSONObject(jsonObject, options: options)
      } catch let error {
        print(error)
        JSONData = nil
      }
      
      if let JSON = JSONData {
        return String(data: JSON, encoding: NSUTF8StringEncoding)
      }
    }
    return nil
  }
}

extension SUMapper where N: Hashable {
  
  /// Maps a JSON array to an object that conforms to Mappable
  public func mapSet(jsonString: String) -> Set<N>? {
    let parsedJSON: AnyObject? = SUMapper.parsejsonString(jsonString)
    
    if let objectArray = mapArray(parsedJSON) {
      return Set(objectArray)
    }
    
    // failed to parse JSON into array form
    // try to parse it into a dictionary and then wrap it in an array
    if let object = map(parsedJSON) {
      return Set([object])
    }
    
    return nil
  }
  
  /// Maps a JSON object to an Set of Mappable objects if it is an array of JSON dictionary, or returns nil.
  public func mapSet(JSON: AnyObject?) -> Set<N>? {
    if let jsonArray = JSON as? [[String : AnyObject]] {
      return mapSet(jsonArray)
    }
    
    return nil
  }
  
  /// Maps an Set of JSON dictionary to an array of Mappable objects
  public func mapSet(jsonArray: [[String : AnyObject]]) -> Set<N> {
    // map every element in JSON array to type N
    return Set(jsonArray.flatMap(map))
  }
  
  ///Maps a Set of Objects to a Set of JSON dictionaries [[String : AnyObject]]
  public func toJSONSet(set: Set<N>) -> [[String : AnyObject]] {
    return set.map {
      // convert every element in set to JSON dictionary equivalent
      self.toJSON($0)
    }
  }
  
  /// Maps a set of Objects to a JSON string with option of pretty formatting
  public func toJSONString(set: Set<N>, prettyPrint: Bool = false) -> String? {
    let JSONDict = toJSONSet(set)
    
    return SUMapper.toJSONString(JSONDict, prettyPrint: prettyPrint)
  }
}

extension Dictionary {
  internal func map<K: Hashable, V>(@noescape function: Element -> (K, V)) -> [K : V] {
    var mapped = [K : V]()
    
    for element in self {
      let newElement = function(element)
      mapped[newElement.0] = newElement.1
    }
    
    return mapped
  }
  
  internal func map<K: Hashable, V>(@noescape function: Element -> (K, [V])) -> [K : [V]] {
    var mapped = [K : [V]]()
    
    for element in self {
      let newElement = function(element)
      mapped[newElement.0] = newElement.1
    }
    
    return mapped
  }
  
  
  internal func filterMap<U>(@noescape function: Value -> U?) -> [Key : U] {
    var mapped = [Key: U]()
    
    for (key, value) in self {
      if let newValue = function(value) {
        mapped[key] = newValue
      }
    }
    
    return mapped
  }
}
