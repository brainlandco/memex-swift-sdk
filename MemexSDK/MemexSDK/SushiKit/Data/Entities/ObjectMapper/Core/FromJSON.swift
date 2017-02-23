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

internal final class FromJSON {
  
  /// Basic type
  class func basicType<FieldType>(inout field: FieldType, object: FieldType?) {
    if let value = object {
      field = value
    }
  }
  
  /// optional basic type
  class func optionalBasicType<FieldType>(inout field: FieldType?, object: FieldType?) {
    field = object
  }
  
  /// Implicitly unwrapped optional basic type
  class func optionalBasicType<FieldType>(inout field: FieldType!, object: FieldType?) {
    field = object
  }
  
  /// Mappable object
  class func object<N: SUMappable>(inout field: N, map: SUMap) {
    if map.toObject {
      SUMapper().map(map.currentValue, toObject: field)
    } else if let value: N = SUMapper().map(map.currentValue) {
      field = value
    }
  }
  
  /// Optional Mappable Object
  class func optionalObject<N: SUMappable>(inout field: N?, map: SUMap) {
    if let field = field where map.toObject && map.currentValue != nil {
      SUMapper().map(map.currentValue, toObject: field)
    } else {
      field = SUMapper().map(map.currentValue)
    }
  }
  
  /// Implicitly unwrapped Optional Mappable Object
  class func optionalObject<N: SUMappable>(inout field: N!, map: SUMap) {
    if let field = field where map.toObject && map.currentValue != nil {
      SUMapper().map(map.currentValue, toObject: field)
    } else {
      field = SUMapper().map(map.currentValue)
    }
  }
  
  /// mappable object array
  class func objectArray<N: SUMappable>(inout field: Array<N>, map: SUMap) {
    if let objects = SUMapper<N>().mapArray(map.currentValue) {
      field = objects
    }
  }
  
  /// optional mappable object array
  class func optionalObjectArray<N: SUMappable>(inout field: Array<N>?, map: SUMap) {
    if let objects: Array<N> = SUMapper().mapArray(map.currentValue) {
      field = objects
    } else {
      field = nil
    }
  }
  
  /// Implicitly unwrapped optional mappable object array
  class func optionalObjectArray<N: SUMappable>(inout field: Array<N>!, map: SUMap) {
    if let objects: Array<N> = SUMapper().mapArray(map.currentValue) {
      field = objects
    } else {
      field = nil
    }
  }
  
  /// mappable object array
  class func twoDimensionalObjectArray<N: SUMappable>(inout field: Array<Array<N>>, map: SUMap) {
    if let objects = SUMapper<N>().mapArrayOfArrays(map.currentValue) {
      field = objects
    }
  }
  
  /// optional mappable 2 dimentional object array
  class func optionalTwoDimensionalObjectArray<N: SUMappable>(inout field: Array<Array<N>>?, map: SUMap) {
    field = SUMapper().mapArrayOfArrays(map.currentValue)
  }
  
  /// Implicitly unwrapped optional 2 dimentional mappable object array
  class func optionalTwoDimensionalObjectArray<N: SUMappable>(inout field: Array<Array<N>>!, map: SUMap) {
    field = SUMapper().mapArrayOfArrays(map.currentValue)
  }
  
  /// Dctionary containing Mappable objects
  class func objectDictionary<N: SUMappable>(inout field: Dictionary<String, N>, map: SUMap) {
    if map.toObject {
      SUMapper<N>().mapDictionary(map.currentValue, toDictionary: field)
    } else {
      if let objects = SUMapper<N>().mapDictionary(map.currentValue) {
        field = objects
      }
    }
  }
  
  /// Optional dictionary containing Mappable objects
  class func optionalObjectDictionary<N: SUMappable>(inout field: Dictionary<String, N>?, map: SUMap) {
    if let field = field where map.toObject && map.currentValue != nil {
      SUMapper().mapDictionary(map.currentValue, toDictionary: field)
    } else {
      field = SUMapper().mapDictionary(map.currentValue)
    }
  }
  
  /// Implicitly unwrapped Dictionary containing Mappable objects
  class func optionalObjectDictionary<N: SUMappable>(inout field: Dictionary<String, N>!, map: SUMap) {
    if let field = field where map.toObject && map.currentValue != nil {
      SUMapper().mapDictionary(map.currentValue, toDictionary: field)
    } else {
      field = SUMapper().mapDictionary(map.currentValue)
    }
  }
  
  /// Dictionary containing Array of Mappable objects
  class func objectDictionaryOfArrays<N: SUMappable>(inout field: Dictionary<String, [N]>, map: SUMap) {
    if let objects = SUMapper<N>().mapDictionaryOfArrays(map.currentValue) {
      field = objects
    }
  }
  
  /// Optional Dictionary containing Array of Mappable objects
  class func optionalObjectDictionaryOfArrays<N: SUMappable>(inout field: Dictionary<String, [N]>?, map: SUMap) {
    field = SUMapper<N>().mapDictionaryOfArrays(map.currentValue)
  }
  
  /// Implicitly unwrapped Dictionary containing Array of Mappable objects
  class func optionalObjectDictionaryOfArrays<N: SUMappable>(inout field: Dictionary<String, [N]>!, map: SUMap) {
    field = SUMapper<N>().mapDictionaryOfArrays(map.currentValue)
  }
  
  /// mappable object Set
  class func objectSet<N: SUMappable>(inout field: Set<N>, map: SUMap) {
    if let objects = SUMapper<N>().mapSet(map.currentValue) {
      field = objects
    }
  }
  
  /// optional mappable object array
  class func optionalObjectSet<N: SUMappable>(inout field: Set<N>?, map: SUMap) {
    field = SUMapper().mapSet(map.currentValue)
  }
  
  /// Implicitly unwrapped optional mappable object array
  class func optionalObjectSet<N: SUMappable>(inout field: Set<N>!, map: SUMap) {
    field = SUMapper().mapSet(map.currentValue)
  }
  
}
