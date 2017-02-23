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

import class Foundation.NSNumber

private func setValue(value: AnyObject, map: SUMap) {
  setValue(value, key: map.currentKey!, checkForNestedKeys: map.keyIsNested, dictionary: &map.jsonDictionary)
}

private func setValue(value: AnyObject, key: String, checkForNestedKeys: Bool, inout dictionary: [String : AnyObject]) {
  if checkForNestedKeys {
    let keyComponents = ArraySlice(key.characters.split { $0 == "." })
    setValue(value, forKeyPathComponents: keyComponents, dictionary: &dictionary)
  } else {
    dictionary[key] = value
  }
}

private func setValue(value: AnyObject,
                      forKeyPathComponents components: ArraySlice<String.CharacterView.SubSequence>,
                                           inout dictionary: [String : AnyObject]) {
  if components.isEmpty {
    return
  }
  
  let head = components.first!
  
  if components.count == 1 {
    dictionary[String(head)] = value
  } else {
    var child = dictionary[String(head)] as? [String : AnyObject]
    if child == nil {
      child = [:]
    }
    
    let tail = components.dropFirst()
    setValue(value, forKeyPathComponents: tail, dictionary: &child!)
    
    dictionary[String(head)] = child
  }
}

internal final class ToJSON {
  
  class func basicType<N>(field: N, map: SUMap) {
    if let x = field as? AnyObject where false
      || x is NSNumber // Basic types
      || x is Bool
      || x is Int
      || x is Double
      || x is Float
      || x is String
      || x is Array<NSNumber> // Arrays
      || x is Array<Bool>
      || x is Array<Int>
      || x is Array<Double>
      || x is Array<Float>
      || x is Array<String>
      || x is Array<AnyObject>
      || x is Array<Dictionary<String, AnyObject>>
      || x is Dictionary<String, NSNumber> // Dictionaries
      || x is Dictionary<String, Bool>
      || x is Dictionary<String, Int>
      || x is Dictionary<String, Double>
      || x is Dictionary<String, Float>
      || x is Dictionary<String, String>
      || x is Dictionary<String, AnyObject> {
      setValue(x, map: map)
    }
  }
  
  class func optionalBasicType<N>(field: N?, map: SUMap) {
    if let field = field {
      basicType(field, map: map)
    }
  }
  
  class func object<N: SUMappable>(field: N, map: SUMap) {
    setValue(SUMapper().toJSON(field), map: map)
  }
  
  class func optionalObject<N: SUMappable>(field: N?, map: SUMap) {
    if let field = field {
      object(field, map: map)
    }
  }
  
  class func objectArray<N: SUMappable>(field: Array<N>, map: SUMap) {
    let jsonObjects = SUMapper().toJSONArray(field)
    
    setValue(jsonObjects, map: map)
  }
  
  class func optionalObjectArray<N: SUMappable>(field: Array<N>?, map: SUMap) {
    if let field = field {
      objectArray(field, map: map)
    }
  }
  
  class func twoDimensionalObjectArray<N: SUMappable>(field: Array<Array<N>>, map: SUMap) {
    var array = [[[String : AnyObject]]]()
    for innerArray in field {
      let jsonObjects = SUMapper().toJSONArray(innerArray)
      array.append(jsonObjects)
    }
    setValue(array, map: map)
  }
  
  class func optionalTwoDimensionalObjectArray<N: SUMappable>(field: Array<Array<N>>?, map: SUMap) {
    if let field = field {
      twoDimensionalObjectArray(field, map: map)
    }
  }
  
  class func objectSet<N: SUMappable where N: Hashable>(field: Set<N>, map: SUMap) {
    let jsonObjects = SUMapper().toJSONSet(field)
    
    setValue(jsonObjects, map: map)
  }
  
  class func optionalObjectSet<N: SUMappable where N: Hashable>(field: Set<N>?, map: SUMap) {
    if let field = field {
      objectSet(field, map: map)
    }
  }
  
  class func objectDictionary<N: SUMappable>(field: Dictionary<String, N>, map: SUMap) {
    let jsonObjects = SUMapper().tojsonDictionary(field)
    
    setValue(jsonObjects, map: map)
  }
  
  class func optionalObjectDictionary<N: SUMappable>(field: Dictionary<String, N>?, map: SUMap) {
    if let field = field {
      objectDictionary(field, map: map)
    }
  }
  
  class func objectDictionaryOfArrays<N: SUMappable>(field: Dictionary<String, [N]>, map: SUMap) {
    let jsonObjects = SUMapper().tojsonDictionaryOfArrays(field)
    
    setValue(jsonObjects, map: map)
  }
  
  class func optionalObjectDictionaryOfArrays<N: SUMappable>(field: Dictionary<String, [N]>?, map: SUMap) {
    if let field = field {
      objectDictionaryOfArrays(field, map: map)
    }
  }
}
