
import Foundation

// MARK: NSData

/// Non Optional
public func <- (left: inout Data, right: Map) {
  left <- (right, Base64Transform())
}
/// Optional
public func <- (left: inout Data?, right: Map) {
  left <- (right, Base64Transform())
}
/// Implicitly Unwrapped Optional
public func <- (left: inout Data!, right: Map) {
  left <- (right, Base64Transform())
}

// MARK: UIColor

/// Non Optional
public func <- (left: inout Color, right: Map) {
  left <- (right, ColorTransform())
}
/// Optional
public func <- (left: inout Color?, right: Map) {
  left <- (right, ColorTransform())
}
/// Implicitly Unwrapped Optional
public func <- (left: inout Color!, right: Map) {
  left <- (right, ColorTransform())
}

// MARK: NSDate

/// Non Optional
public func <- (left: inout Date, right: Map) {
  left <- (right, ISO8601DateTransform())
}
/// Optional
public func <- (left: inout Date?, right: Map) {
  left <- (right, ISO8601DateTransform())
}
/// Implicitly Unwrapped Optional
public func <- (left: inout Date!, right: Map) {
  left <- (right, ISO8601DateTransform())
}

// MARK: NSDecimalNumber

/// Non Optional
public func <- (left: inout NSDecimalNumber, right: Map) {
  left <- (right, DecimalNumberTransform())
}
/// Optional
public func <- (left: inout NSDecimalNumber?, right: Map) {
  left <- (right, DecimalNumberTransform())
}
/// Implicitly Unwrapped Optional
public func <- (left: inout NSDecimalNumber!, right: Map) {
  left <- (right, DecimalNumberTransform())
}

// MARK: URL

/// Non Optional
public func <- (left: inout URL, right: Map) {
  left <- (right, URLTransform())
}
/// Optional
public func <- (left: inout URL?, right: Map) {
  left <- (right, URLTransform())
}
/// Implicitly Unwrapped Optional
public func <- (left: inout URL!, right: Map) {
  left <- (right, URLTransform())
}
