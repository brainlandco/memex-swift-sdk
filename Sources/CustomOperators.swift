
import Foundation
import ObjectMapper

// MARK: NSData

/// Non Optional
func <- (left: inout Data, right: Map) {
  left <- (right, Base64Transform())
}
/// Optional
func <- (left: inout Data?, right: Map) {
  left <- (right, Base64Transform())
}
/// Implicitly Unwrapped Optional
func <- (left: inout Data!, right: Map) {
  left <- (right, Base64Transform())
}

// MARK: Color

/// Non Optional
func <- (left: inout Color, right: Map) {
  left <- (right, ColorTransform())
}
/// Optional
func <- (left: inout Color?, right: Map) {
  left <- (right, ColorTransform())
}
/// Implicitly Unwrapped Optional
func <- (left: inout Color!, right: Map) {
  left <- (right, ColorTransform())
}

// MARK: Date

/// Non Optional
func <- (left: inout Date, right: Map) {
  left <- (right, ISO8601DateTransform())
}
/// Optional
func <- (left: inout Date?, right: Map) {
  left <- (right, ISO8601DateTransform())
}
/// Implicitly Unwrapped Optional
func <- (left: inout Date!, right: Map) {
  left <- (right, ISO8601DateTransform())
}

// MARK: NSDecimalNumber

/// Non Optional
func <- (left: inout NSDecimalNumber, right: Map) {
  left <- (right, DecimalNumberTransform())
}
/// Optional
func <- (left: inout NSDecimalNumber?, right: Map) {
  left <- (right, DecimalNumberTransform())
}
/// Implicitly Unwrapped Optional
func <- (left: inout NSDecimalNumber!, right: Map) {
  left <- (right, DecimalNumberTransform())
}

// MARK: URL

/// Non Optional
func <- (left: inout URL, right: Map) {
  left <- (right, URLTransform())
}
/// Optional
func <- (left: inout URL?, right: Map) {
  left <- (right, URLTransform())
}
/// Implicitly Unwrapped Optional
func <- (left: inout URL!, right: Map) {
  left <- (right, URLTransform())
}
