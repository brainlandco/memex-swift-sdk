
extension Dictionary {
  
  public mutating func unionInPlace(dictionary: Dictionary) {
    dictionary.forEach { self.updateValue($1, forKey: $0) }
  }
  
  public func union(dictionary: Dictionary) -> Dictionary {
    var dictionary = dictionary
    dictionary.unionInPlace(dictionary: self)
    return dictionary
  }
}
