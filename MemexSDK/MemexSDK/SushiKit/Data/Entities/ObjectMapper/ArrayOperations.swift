// ******************************************************************************
//
// Copyright © 2015, Adam Zdara. All rights reserved.
// Author: Adam Zdara
//
// All rights reserved. This source code can be used only for purposes specified
// by the given license contract signed by the rightful deputy of Adam Zdara.
// This source code can be used only by the owner of the license.
//
// Any disputes arising in respect of this agreement (license) shall be brought
// before the Municipal Court of Prague.
//
// ******************************************************************************


import Foundation
import UIKit

// MARK:- Array of Mappable objects - Array<T: SUMappable>

/// Array of Mappable objects
public func <-> <T: SUMappable>(inout left: Array<T>, right: SUMap) {
  switch right.mappingType {
  case .FromJSON where right.isKeyPresent:
    FromJSON.objectArray(&left, map: right)
  case .ToJSON:
    ToJSON.objectArray(left, map: right)
  default: ()
  }
}

/// Optional array of Mappable objects
public func <-> <T: SUMappable>(inout left: Array<T>?, right: SUMap) {
  switch right.mappingType {
  case .FromJSON where right.isKeyPresent:
    FromJSON.optionalObjectArray(&left, map: right)
  case .ToJSON:
    ToJSON.optionalObjectArray(left, map: right)
  default: ()
  }
}

/// Implicitly unwrapped Optional array of Mappable objects
public func <-> <T: SUMappable>(inout left: Array<T>!, right: SUMap) {
  switch right.mappingType {
  case .FromJSON where right.isKeyPresent:
    FromJSON.optionalObjectArray(&left, map: right)
  case .ToJSON:
    ToJSON.optionalObjectArray(left, map: right)
  default: ()
  }
}

// MARK:- Array of Mappable objects with transforms - Array<T: SUMappable>

/// Array of Mappable objects
public func <-> <Transform: SUTransformType where Transform.Object: SUMappable>(inout left: Array<Transform.Object>,
                 right: (SUMap, Transform)) {
  let (map, transform) = right
  switch map.mappingType {
  case .FromJSON where map.isKeyPresent:
    if let transformedValues = fromJSONArrayWithTransform(map.currentValue, transform: transform) {
      FromJSON.basicType(&left, object: transformedValues)
    }
  case .ToJSON:
    let transformedValues = toJSONArrayWithTransform(left, transform: transform)
    ToJSON.optionalBasicType(transformedValues, map: map)
  default: ()
  }
}

/// Optional array of Mappable objects
public func <-> <Transform: SUTransformType where Transform.Object: SUMappable>(inout left: Array<Transform.Object>?,
                 right: (SUMap, Transform)) {
  let (map, transform) = right
  switch map.mappingType {
  case .FromJSON where map.isKeyPresent:
    let transformedValues = fromJSONArrayWithTransform(map.currentValue, transform: transform)
    FromJSON.optionalBasicType(&left, object: transformedValues)
  case .ToJSON:
    let transformedValues = toJSONArrayWithTransform(left, transform: transform)
    ToJSON.optionalBasicType(transformedValues, map: map)
  default: ()
  }
}

/// Implicitly unwrapped Optional array of Mappable objects
public func <-> <Transform: SUTransformType where Transform.Object: SUMappable>(inout left: Array<Transform.Object>!,
                 right: (SUMap, Transform)) {
  let (map, transform) = right
  switch map.mappingType {
  case .FromJSON where map.isKeyPresent:
    let transformedValues = fromJSONArrayWithTransform(map.currentValue, transform: transform)
    FromJSON.optionalBasicType(&left, object: transformedValues)
  case .ToJSON:
    let transformedValues = toJSONArrayWithTransform(left, transform: transform)
    ToJSON.optionalBasicType(transformedValues, map: map)
  default: ()
  }
}

// MARK:- Array of Array of Mappable objects - Array<Array<T: SUMappable>>

/// Array of Array Mappable objects
public func <-> <T: SUMappable>(inout left: Array<Array<T>>, right: SUMap) {
  switch right.mappingType {
  case .FromJSON where right.isKeyPresent:
    FromJSON.twoDimensionalObjectArray(&left, map: right)
  case .ToJSON:
    ToJSON.twoDimensionalObjectArray(left, map: right)
  default: ()
  }
}

/// Optional array of Mappable objects
public func <-> <T: SUMappable>(inout left: Array<Array<T>>?, right: SUMap) {
  switch right.mappingType {
  case .FromJSON where right.isKeyPresent:
    FromJSON.optionalTwoDimensionalObjectArray(&left, map: right)
  case .ToJSON:
    ToJSON.optionalTwoDimensionalObjectArray(left, map: right)
  default: ()
  }
}

/// Implicitly unwrapped Optional array of Mappable objects
public func <-> <T: SUMappable>(inout left: Array<Array<T>>!, right: SUMap) {
  switch right.mappingType {
  case .FromJSON where right.isKeyPresent:
    FromJSON.optionalTwoDimensionalObjectArray(&left, map: right)
  case .ToJSON:
    ToJSON.optionalTwoDimensionalObjectArray(left, map: right)
  default: ()
  }
}

// MARK:- Array of Array of Mappable objects - Array<Array<T: SUMappable>> with transforms

/// Array of Array Mappable objects with transform
public func <-> <Transform: SUTransformType where Transform.Object: SUMappable>(
  inout left: Array<Array<Transform.Object>>, right: (SUMap, Transform)) {
  let (map, transform) = right
  if let original2DArray = map.currentValue as? [[AnyObject]] where map.mappingType == .FromJSON && map.isKeyPresent {
    let transformed2DArray = original2DArray.flatMap { values in
      fromJSONArrayWithTransform(values, transform: transform)
    }
    FromJSON.basicType(&left, object: transformed2DArray)
  } else if map.mappingType == .ToJSON {
    let transformed2DArray = left.flatMap { values in
      toJSONArrayWithTransform(values, transform: transform)
    }
    ToJSON.basicType(transformed2DArray, map: map)
  }
}

/// Optional array of Mappable objects with transform
public func <-> <Transform: SUTransformType where Transform.Object: SUMappable>(
  inout left: Array<Array<Transform.Object>>?, right: (SUMap, Transform)) {
  let (map, transform) = right
  if let original2DArray = map.currentValue as? [[AnyObject]] where map.mappingType == .FromJSON && map.isKeyPresent {
    let transformed2DArray = original2DArray.flatMap { values in
      fromJSONArrayWithTransform(values, transform: transform)
    }
    FromJSON.optionalBasicType(&left, object: transformed2DArray)
  } else if map.mappingType == .ToJSON {
    let transformed2DArray = left?.flatMap { values in
      toJSONArrayWithTransform(values, transform: transform)
    }
    ToJSON.optionalBasicType(transformed2DArray, map: map)
  }
}

/// Implicitly unwrapped Optional array of Mappable objects with transform
public func <-> <Transform: SUTransformType where Transform.Object: SUMappable>(
  inout left: Array<Array<Transform.Object>>!, right: (SUMap, Transform)) {
  let (map, transform) = right
  if let original2DArray = map.currentValue as? [[AnyObject]] where map.mappingType == .FromJSON && map.isKeyPresent {
    let transformed2DArray = original2DArray.flatMap { values in
      fromJSONArrayWithTransform(values, transform: transform)
    }
    FromJSON.optionalBasicType(&left, object: transformed2DArray)
  } else if map.mappingType == .ToJSON {
    let transformed2DArray = left?.flatMap { values in
      toJSONArrayWithTransform(values, transform: transform)
    }
    ToJSON.optionalBasicType(transformed2DArray, map: map)
  }
}
