
extension Array {
  
  /**
   Removes object from array.
   
   - parameter object: Object thaat will be removed from array.
   
   - returns: Returns removed object. If there is any, otherwise it returns nil.
   */
  mutating func removeObject<U: Equatable>(object: U) -> U? {
    var foundIndex: Int?
    for (index, other) in self.enumerated() {
      if let to = other as? U {
        if object == to {
          foundIndex = index
        }
      }
    }
    if foundIndex != nil {
      self.remove(at: foundIndex!)
      return object
    } else {
      return nil
    }
  }
  
}
