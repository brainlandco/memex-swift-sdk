
extension Array {
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
