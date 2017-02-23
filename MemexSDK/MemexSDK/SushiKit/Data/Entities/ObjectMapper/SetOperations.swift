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

// MARK:- Set of Mappable objects - Set<T: SUMappable where T: Hashable>

/// Set of Mappable objects
public func <-> <T: SUMappable where T: Hashable>(inout left: Set<T>, right: SUMap) {
  switch right.mappingType {
  case .FromJSON where right.isKeyPresent:
    FromJSON.objectSet(&left, map: right)
  case .ToJSON:
    ToJSON.objectSet(left, map: right)
  default: ()
  }
}


/// Optional Set of Mappable objects
public func <-> <T: SUMappable where T: Hashable>(inout left: Set<T>?, right: SUMap) {
  switch right.mappingType {
  case .FromJSON where right.isKeyPresent:
    FromJSON.optionalObjectSet(&left, map: right)
  case .ToJSON:
    ToJSON.optionalObjectSet(left, map: right)
  default: ()
  }
}

/// Implicitly unwrapped Optional Set of Mappable objects
public func <-> <T: SUMappable where T: Hashable>(inout left: Set<T>!, right: SUMap) {
  switch right.mappingType {
  case .FromJSON where right.isKeyPresent:
    FromJSON.optionalObjectSet(&left, map: right)
  case .ToJSON:
    ToJSON.optionalObjectSet(left, map: right)
  default: ()
  }
}


// MARK:- Set of Mappable objects with a transform - Set<T: SUMappable where T: Hashable>

/// Set of Mappable objects with transform
public func <-> <Transform: SUTransformType where Transform.Object: protocol<Hashable, SUMappable>>(
  inout left: Set<Transform.Object>, right: (SUMap, Transform)) {
  let (map, transform) = right
  switch map.mappingType {
  case .FromJSON where map.isKeyPresent:
    if let transformedValues = fromJSONArrayWithTransform(map.currentValue, transform: transform) {
      FromJSON.basicType(&left, object: Set(transformedValues))
    }
  case .ToJSON:
    let transformedValues = toJSONArrayWithTransform(Array(left), transform: transform)
    ToJSON.optionalBasicType(transformedValues, map: map)
  default: ()
  }
}


/// Optional Set of Mappable objects with transform
public func <-> <Transform: SUTransformType where Transform.Object: protocol<Hashable, SUMappable>>(
  inout left: Set<Transform.Object>?, right: (SUMap, Transform)) {
  let (map, transform) = right
  switch map.mappingType {
  case .FromJSON where map.isKeyPresent:
    if let transformedValues = fromJSONArrayWithTransform(map.currentValue, transform: transform) {
      FromJSON.basicType(&left, object: Set(transformedValues))
    }
  case .ToJSON:
    if let values = left {
      let transformedValues = toJSONArrayWithTransform(Array(values), transform: transform)
      ToJSON.optionalBasicType(transformedValues, map: map)
    }
  default: ()
  }
}

/// Implicitly unwrapped Optional set of Mappable objects with transform
public func <-> <Transform: SUTransformType where Transform.Object: protocol<Hashable, SUMappable>>(
  inout left: Set<Transform.Object>!, right: (SUMap, Transform)) {
  let (map, transform) = right
  switch map.mappingType {
  case .FromJSON where map.isKeyPresent:
    if let transformedValues = fromJSONArrayWithTransform(map.currentValue, transform: transform) {
      FromJSON.basicType(&left, object: Set(transformedValues))
    }
  case .ToJSON:
    if let values = left {
      let transformedValues = toJSONArrayWithTransform(Array(values), transform: transform)
      ToJSON.optionalBasicType(transformedValues, map: map)
    }
  default: ()
  }
}

