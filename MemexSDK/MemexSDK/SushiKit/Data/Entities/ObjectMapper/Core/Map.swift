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

/// A class used for holding mapping data
public final class SUMap {
  public let mappingType: SUMappingType
  
  public internal(set) var jsonDictionary: [String : AnyObject] = [:]
  public internal(set) var isKeyPresent = false
  public var currentValue: AnyObject?
  var currentKey: String?
  var keyIsNested = false
  
  let toObject: Bool // indicates whether the mapping is being applied to an existing object
  
  /// Counter for failing cases of deserializing values to `let` properties.
  private var failedCount: Int = 0
  
  public init(mappingType: SUMappingType, jsonDictionary: [String : AnyObject], toObject: Bool = false) {
    self.mappingType = mappingType
    self.jsonDictionary = jsonDictionary
    self.toObject = toObject
  }
  
  /// Sets the current mapper value and key.
  /// The Key paramater can be a period separated string (ex. "distance.value") to access sub objects.
  public subscript(key: String) -> SUMap {
    // save key and value associated to it
    let nested = key.containsString(".")
    return self[key, nested: nested]
  }
  
  public subscript(key: String, nested nested: Bool) -> SUMap {
    // save key and value associated to it
    currentKey = key
    keyIsNested = nested
    
    // check if a value exists for the current key
    // do this pre-check for performance reasons
    if nested == false {
      let object = jsonDictionary[key], isNSNull = object is NSNull
      isKeyPresent = isNSNull ? true : object != nil
      currentValue = isNSNull ? nil : object
    } else {
      // break down the components of the key that are separated by .
      (isKeyPresent, currentValue) = valueFor(ArraySlice(key.componentsSeparatedByString(".")), dictionary: jsonDictionary)
    }
    
    return self
  }
  
  // MARK: Immutable Mapping
  
  public func value<T>() -> T? {
    return currentValue as? T
  }
  
  public func valueOr<T>(@autoclosure defaultValue: () -> T) -> T {
    return value() ?? defaultValue()
  }
  
  /// Returns current JSON value of type `T` if it is existing, or returns a
  /// unusable proxy value for `T` and collects failed count.
  public func valueOrFail<T>() -> T {
    if let value: T = value() {
      return value
    } else {
      // Collects failed count
      failedCount += 1
      
      // Returns dummy memory as a proxy for type `T`
      let pointer = UnsafeMutablePointer<T>.alloc(0)
      pointer.dealloc(0)
      return pointer.memory
    }
  }
  
  /// Returns whether the receiver is success or failure.
  public var isValid: Bool {
    return failedCount == 0
  }
}

/// Fetch value from JSON dictionary, loop through keyPathComponents until we reach the desired object
private func valueFor(keyPathComponents: ArraySlice<String>, dictionary: [String: AnyObject]) -> (Bool, AnyObject?) {
  // Implement it as a tail recursive function.
  if keyPathComponents.isEmpty {
    return (false, nil)
  }
  
  if let keyPath = keyPathComponents.first {
    let object = dictionary[keyPath]
    if object is NSNull {
      return (true, nil)
    } else if let dict = object as? [String : AnyObject] where keyPathComponents.count > 1 {
      let tail = keyPathComponents.dropFirst()
      return valueFor(tail, dictionary: dict)
    } else if let array = object as? [AnyObject] where keyPathComponents.count > 1 {
      let tail = keyPathComponents.dropFirst()
      return valueFor(tail, array: array)
    } else {
      return (object != nil, object)
    }
  }
  
  return (false, nil)
}

/// Fetch value from JSON Array, loop through keyPathComponents them until we reach the desired object
private func valueFor(keyPathComponents: ArraySlice<String>, array: [AnyObject]) -> (Bool, AnyObject?) {
  // Implement it as a tail recursive function.
  
  if keyPathComponents.isEmpty {
    return (false, nil)
  }
  
  //Try to convert keypath to Int as index
  if let keyPath = keyPathComponents.first,
    let index = Int(keyPath) where index >= 0 && index < array.count {
    
    let object = array[index]
    
    if object is NSNull {
      return (true, nil)
    } else if let array = object as? [AnyObject] where keyPathComponents.count > 1 {
      let tail = keyPathComponents.dropFirst()
      return valueFor(tail, array: array)
    } else if let dict = object as? [String : AnyObject] where keyPathComponents.count > 1 {
      let tail = keyPathComponents.dropFirst()
      return valueFor(tail, dictionary: dict)
    } else {
      return (true, object)
    }
  }
  
  return (false, nil)
}
