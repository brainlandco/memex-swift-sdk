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


infix operator <-> {}

func fromJSONArrayWithTransform<Transform: SUTransformType>(input: AnyObject?,
                                        transform: Transform) -> [Transform.Object]? {
  if let values = input as? [AnyObject] {
    return values.flatMap { value in
      return transform.transformFromJSON(value)
    }
  } else {
    return nil
  }
}

func fromJSONDictionaryWithTransform<Transform: SUTransformType>(input: AnyObject?,
                                             transform: Transform) -> [String: Transform.Object]? {
  if let values = input as? [String: AnyObject] {
    return values.filterMap { value in
      return transform.transformFromJSON(value)
    }
  } else {
    return nil
  }
}

func toJSONArrayWithTransform<Transform: SUTransformType>(input: [Transform.Object]?,
                                      transform: Transform) -> [Transform.JSON]? {
  return input?.flatMap { value in
    return transform.transformToJSON(value)
  }
}

func toJSONDictionaryWithTransform<Transform: SUTransformType>(input: [String: Transform.Object]?,
                                           transform: Transform) -> [String: Transform.JSON]? {
  return input?.filterMap { value in
    return transform.transformToJSON(value)
  }
}


// MARK:- Objects with Basic types

/// Object of Basic type
public func <-> <T>(inout left: T, right: SUMap) {
  switch right.mappingType {
  case .FromJSON where right.isKeyPresent:
    FromJSON.basicType(&left, object: right.value())
  case .ToJSON:
    ToJSON.basicType(left, map: right)
  default: ()
  }
}

/// Optional object of basic type
public func <-> <T>(inout left: T?, right: SUMap) {
  switch right.mappingType {
  case .FromJSON where right.isKeyPresent:
    FromJSON.optionalBasicType(&left, object: right.value())
  case .ToJSON:
    ToJSON.optionalBasicType(left, map: right)
  default: ()
  }
}

/// Implicitly unwrapped optional object of basic type
public func <-> <T>(inout left: T!, right: SUMap) {
  switch right.mappingType {
  case .FromJSON where right.isKeyPresent:
    FromJSON.optionalBasicType(&left, object: right.value())
  case .ToJSON:
    ToJSON.optionalBasicType(left, map: right)
  default: ()
  }
}
// MARK:- Transforms

/// Object of Basic type with Transform
public func <-> <Transform: SUTransformType>(inout left: Transform.Object, right: (SUMap, Transform)) {
  let (map, transform) = right
  switch map.mappingType {
  case .FromJSON where map.isKeyPresent:
    let value = transform.transformFromJSON(map.currentValue)
    FromJSON.basicType(&left, object: value)
  case .ToJSON:
    let value: Transform.JSON? = transform.transformToJSON(left)
    ToJSON.optionalBasicType(value, map: map)
  default: ()
  }
}

/// Optional object of basic type with Transform
public func <-> <Transform: SUTransformType>(inout left: Transform.Object?, right: (SUMap, Transform)) {
  let (map, transform) = right
  switch map.mappingType {
  case .FromJSON where map.isKeyPresent:
    let value = transform.transformFromJSON(map.currentValue)
    FromJSON.optionalBasicType(&left, object: value)
  case .ToJSON:
    let value: Transform.JSON? = transform.transformToJSON(left)
    ToJSON.optionalBasicType(value, map: map)
  default: ()
  }
}

/// Implicitly unwrapped optional object of basic type with Transform
public func <-> <Transform: SUTransformType>(inout left: Transform.Object!, right: (SUMap, Transform)) {
  let (map, transform) = right
  switch map.mappingType {
  case .FromJSON where map.isKeyPresent:
    let value = transform.transformFromJSON(map.currentValue)
    FromJSON.optionalBasicType(&left, object: value)
  case .ToJSON:
    let value: Transform.JSON? = transform.transformToJSON(left)
    ToJSON.optionalBasicType(value, map: map)
  default: ()
  }
}

/// Array of Basic type with Transform
public func <-> <Transform: SUTransformType>(inout left: [Transform.Object], right: (SUMap, Transform)) {
  let (map, transform) = right
  switch map.mappingType {
  case .FromJSON where map.isKeyPresent:
    let values = fromJSONArrayWithTransform(map.currentValue, transform: transform)
    FromJSON.basicType(&left, object: values)
  case .ToJSON:
    let values = toJSONArrayWithTransform(left, transform: transform)
    ToJSON.optionalBasicType(values, map: map)
  default: ()
  }
}

/// Optional array of Basic type with Transform
public func <-> <Transform: SUTransformType>(inout left: [Transform.Object]?, right: (SUMap, Transform)) {
  let (map, transform) = right
  switch map.mappingType {
  case .FromJSON where map.isKeyPresent:
    let values = fromJSONArrayWithTransform(map.currentValue, transform: transform)
    FromJSON.optionalBasicType(&left, object: values)
  case .ToJSON:
    let values = toJSONArrayWithTransform(left, transform: transform)
    ToJSON.optionalBasicType(values, map: map)
  default: ()
  }
}

/// Implicitly unwrapped optional array of Basic type with Transform
public func <-> <Transform: SUTransformType>(inout left: [Transform.Object]!, right: (SUMap, Transform)) {
  let (map, transform) = right
  switch map.mappingType {
  case .FromJSON where map.isKeyPresent:
    let values = fromJSONArrayWithTransform(map.currentValue, transform: transform)
    FromJSON.optionalBasicType(&left, object: values)
  case .ToJSON:
    let values = toJSONArrayWithTransform(left, transform: transform)
    ToJSON.optionalBasicType(values, map: map)
  default: ()
  }
}

/// Dictionary of Basic type with Transform
public func <-> <Transform: SUTransformType>(inout left: [String: Transform.Object], right: (SUMap, Transform)) {
  let (map, transform) = right
  switch map.mappingType {
  case .FromJSON where map.isKeyPresent:
    let values = fromJSONDictionaryWithTransform(map.currentValue, transform: transform)
    FromJSON.basicType(&left, object: values)
  case .ToJSON:
    let values = toJSONDictionaryWithTransform(left, transform: transform)
    ToJSON.optionalBasicType(values, map: map)
  default: ()
  }
}

/// Optional dictionary of Basic type with Transform
public func <-> <Transform: SUTransformType>(inout left: [String: Transform.Object]?, right: (SUMap, Transform)) {
  let (map, transform) = right
  switch map.mappingType {
  case .FromJSON where map.isKeyPresent:
    let values = fromJSONDictionaryWithTransform(map.currentValue, transform: transform)
    FromJSON.optionalBasicType(&left, object: values)
  case .ToJSON:
    let values = toJSONDictionaryWithTransform(left, transform: transform)
    ToJSON.optionalBasicType(values, map: map)
  default: ()
  }
}

/// Implicitly unwrapped optional dictionary of Basic type with Transform
public func <-> <Transform: SUTransformType>(inout left: [String: Transform.Object]!, right: (SUMap, Transform)) {
  let (map, transform) = right
  switch map.mappingType {
  case .FromJSON where map.isKeyPresent:
    let values = fromJSONDictionaryWithTransform(map.currentValue, transform: transform)
    FromJSON.optionalBasicType(&left, object: values)
  case .ToJSON:
    let values = toJSONDictionaryWithTransform(left, transform: transform)
    ToJSON.optionalBasicType(values, map: map)
  default: ()
  }
}


// MARK:- Mappable Objects - <T: SUMappable>

/// Object conforming to Mappable
public func <-> <T: SUMappable>(inout left: T, right: SUMap) {
  switch right.mappingType {
  case .FromJSON:
    FromJSON.object(&left, map: right)
  case .ToJSON:
    ToJSON.object(left, map: right)
  }
}

/// Optional Mappable objects
public func <-> <T: SUMappable>(inout left: T?, right: SUMap) {
  switch right.mappingType {
  case .FromJSON where right.isKeyPresent:
    FromJSON.optionalObject(&left, map: right)
  case .ToJSON:
    ToJSON.optionalObject(left, map: right)
  default: ()
  }
}

/// Implicitly unwrapped optional Mappable objects
public func <-> <T: SUMappable>(inout left: T!, right: SUMap) {
  switch right.mappingType {
  case .FromJSON where right.isKeyPresent:
    FromJSON.optionalObject(&left, map: right)
  case .ToJSON:
    ToJSON.optionalObject(left, map: right)
  default: ()
  }
}

// MARK:- Transforms of Mappable Objects - <T: SUMappable>

/// Object conforming to Mappable that have transforms
public func <-> <Transform: SUTransformType where Transform.Object: SUMappable>(
  inout left: Transform.Object, right: (SUMap, Transform)) {
  let (map, transform) = right
  switch map.mappingType {
  case .FromJSON where map.isKeyPresent:
    let value: Transform.Object? = transform.transformFromJSON(map.currentValue)
    FromJSON.basicType(&left, object: value)
  case .ToJSON:
    let value: Transform.JSON? = transform.transformToJSON(left)
    ToJSON.optionalBasicType(value, map: map)
  default: ()
  }
}

/// Optional Mappable objects that have transforms
public func <-> <Transform: SUTransformType where Transform.Object: SUMappable>(
  inout left: Transform.Object?, right: (SUMap, Transform)) {
  let (map, transform) = right
  switch map.mappingType {
  case .FromJSON where map.isKeyPresent:
    let value: Transform.Object? = transform.transformFromJSON(map.currentValue)
    FromJSON.optionalBasicType(&left, object: value)
  case .ToJSON:
    let value: Transform.JSON? = transform.transformToJSON(left)
    ToJSON.optionalBasicType(value, map: map)
  default: ()
  }
}

/// Implicitly unwrapped optional Mappable objects that have transforms
public func <-> <Transform: SUTransformType where Transform.Object: SUMappable>(inout left: Transform.Object!,
                 right: (SUMap, Transform)) {
  let (map, transform) = right
  switch map.mappingType {
  case .FromJSON where map.isKeyPresent:
    let value: Transform.Object? = transform.transformFromJSON(map.currentValue)
    FromJSON.optionalBasicType(&left, object: value)
  case .ToJSON:
    let value: Transform.JSON? = transform.transformToJSON(left)
    ToJSON.optionalBasicType(value, map: map)
  default: ()
  }
}

// MARK:- Dictionary of Mappable objects - Dictionary<String, T: SUMappable>

/// Dictionary of Mappable objects <String, T: SUMappable>
public func <-> <T: SUMappable>(inout left: Dictionary<String, T>, right: SUMap) {
  switch right.mappingType {
  case .FromJSON where right.isKeyPresent:
    FromJSON.objectDictionary(&left, map: right)
  case .ToJSON:
    ToJSON.objectDictionary(left, map: right)
  default: ()
  }
}

/// Optional Dictionary of Mappable object <String, T: SUMappable>
public func <-> <T: SUMappable>(inout left: Dictionary<String, T>?, right: SUMap) {
  switch right.mappingType {
  case .FromJSON where right.isKeyPresent:
    FromJSON.optionalObjectDictionary(&left, map: right)
  case .ToJSON:
    ToJSON.optionalObjectDictionary(left, map: right)
  default: ()
  }
}

/// Implicitly unwrapped Optional Dictionary of Mappable object <String, T: SUMappable>
public func <-> <T: SUMappable>(inout left: Dictionary<String, T>!, right: SUMap) {
  switch right.mappingType {
  case .FromJSON where right.isKeyPresent:
    FromJSON.optionalObjectDictionary(&left, map: right)
  case .ToJSON:
    ToJSON.optionalObjectDictionary(left, map: right)
  default: ()
  }
}

/// Dictionary of Mappable objects <String, T: SUMappable>
public func <-> <T: SUMappable>(inout left: Dictionary<String, [T]>, right: SUMap) {
  switch right.mappingType {
  case .FromJSON where right.isKeyPresent:
    FromJSON.objectDictionaryOfArrays(&left, map: right)
  case .ToJSON:
    ToJSON.objectDictionaryOfArrays(left, map: right)
  default: ()
  }
}

/// Optional Dictionary of Mappable object <String, T: SUMappable>
public func <-> <T: SUMappable>(inout left: Dictionary<String, [T]>?, right: SUMap) {
  switch right.mappingType {
  case .FromJSON where right.isKeyPresent:
    FromJSON.optionalObjectDictionaryOfArrays(&left, map: right)
  case .ToJSON:
    ToJSON.optionalObjectDictionaryOfArrays(left, map: right)
  default: ()
  }
}

/// Implicitly unwrapped Optional Dictionary of Mappable object <String, T: SUMappable>
public func <-> <T: SUMappable>(inout left: Dictionary<String, [T]>!, right: SUMap) {
  switch right.mappingType {
  case .FromJSON where right.isKeyPresent:
    FromJSON.optionalObjectDictionaryOfArrays(&left, map: right)
  case .ToJSON:
    ToJSON.optionalObjectDictionaryOfArrays(left, map: right)
  default: ()
  }
}

// MARK:- Dictionary of Mappable objects with a transform - Dictionary<String, T: SUMappable>

/// Dictionary of Mappable objects <String, T: SUMappable> with a transform
public func <-> <Transform: SUTransformType where Transform.Object: SUMappable>(
  inout left: Dictionary<String, Transform.Object>, right: (SUMap, Transform)) {
  let (map, transform) = right
  if let object = map.currentValue as? [String : AnyObject] where map.mappingType == .FromJSON && map.isKeyPresent {
    let value = fromJSONDictionaryWithTransform(object, transform: transform) ?? left
    FromJSON.basicType(&left, object: value)
  } else if map.mappingType == .ToJSON {
    let value = toJSONDictionaryWithTransform(left, transform: transform)
    ToJSON.basicType(value, map: map)
  }
}

/// Optional Dictionary of Mappable object <String, T: SUMappable> with a transform
public func <-> <Transform: SUTransformType where Transform.Object: SUMappable>(
  inout left: Dictionary<String, Transform.Object>?, right: (SUMap, Transform)) {
  let (map, transform) = right
  if let object = map.currentValue as? [String : AnyObject] where map.mappingType == .FromJSON && map.isKeyPresent {
    let value = fromJSONDictionaryWithTransform(object, transform: transform) ?? left
    FromJSON.optionalBasicType(&left, object: value)
  } else if map.mappingType == .ToJSON {
    let value = toJSONDictionaryWithTransform(left, transform: transform)
    ToJSON.optionalBasicType(value, map: map)
  }
}

/// Implicitly unwrapped Optional Dictionary of Mappable object <String, T: SUMappable> with a transform
public func <-> <Transform: SUTransformType where Transform.Object: SUMappable>(
  inout left: Dictionary<String, Transform.Object>!, right: (SUMap, Transform)) {
  let (map, transform) = right
  if let dictionary = map.currentValue as? [String : AnyObject] where map.mappingType == .FromJSON && map.isKeyPresent {
    let transformedDictionary = fromJSONDictionaryWithTransform(dictionary, transform: transform) ?? left
    FromJSON.optionalBasicType(&left, object: transformedDictionary)
  } else if map.mappingType == .ToJSON {
    let value = toJSONDictionaryWithTransform(left, transform: transform)
    ToJSON.optionalBasicType(value, map: map)
  }
}

/// Dictionary of Mappable objects <String, T: SUMappable> with a transform
public func <-> <Transform: SUTransformType where Transform.Object: SUMappable>(
  inout left: Dictionary<String, [Transform.Object]>, right: (SUMap, Transform)) {
  let (map, transform) = right
  if let dictionary = map.currentValue as? [String : [AnyObject]] where map.mappingType == .FromJSON && map.isKeyPresent {
    let transformedDictionary = dictionary.map { (key, values) in
      return (key, fromJSONArrayWithTransform(values, transform: transform) ?? left[key] ?? [])
    }
    FromJSON.basicType(&left, object: transformedDictionary)
  } else if map.mappingType == .ToJSON {
    let transformedDictionary = left.map { (key, values) in
      return (key, toJSONArrayWithTransform(values, transform: transform) ?? [])
    }
    
    ToJSON.basicType(transformedDictionary, map: map)
  }
}

/// Optional Dictionary of Mappable object <String, T: SUMappable> with a transform
public func <-> <Transform: SUTransformType where Transform.Object: SUMappable>(
  inout left: Dictionary<String, [Transform.Object]>?, right: (SUMap, Transform)) {
  let (map, transform) = right
  if let dictionary = map.currentValue as? [String : [AnyObject]] where map.mappingType == .FromJSON && map.isKeyPresent {
    let transformedDictionary = dictionary.map { (key, values) in
      return (key, fromJSONArrayWithTransform(values, transform: transform) ?? left?[key] ?? [])
    }
    FromJSON.optionalBasicType(&left, object: transformedDictionary)
  } else if map.mappingType == .ToJSON {
    let transformedDictionary = left?.map { (key, values) in
      return (key, toJSONArrayWithTransform(values, transform: transform) ?? [])
    }
    
    ToJSON.optionalBasicType(transformedDictionary, map: map)
  }
}

/// Implicitly unwrapped Optional Dictionary of Mappable object <String, T: SUMappable> with a transform
public func <-> <Transform: SUTransformType where Transform.Object: SUMappable>(
  inout left: Dictionary<String, [Transform.Object]>!, right: (SUMap, Transform)) {
  let (map, transform) = right
  if let dictionary = map.currentValue as? [String : [AnyObject]] where map.mappingType == .FromJSON && map.isKeyPresent {
    let transformedDictionary = dictionary.map { (key, values) in
      return (key, fromJSONArrayWithTransform(values, transform: transform) ?? left?[key] ?? [])
    }
    FromJSON.optionalBasicType(&left, object: transformedDictionary)
  } else if map.mappingType == .ToJSON {
    let transformedDictionary = left?.map { (key, values) in
      return (key, toJSONArrayWithTransform(values, transform: transform) ?? [])
    }
    
    ToJSON.optionalBasicType(transformedDictionary, map: map)
  }
}
