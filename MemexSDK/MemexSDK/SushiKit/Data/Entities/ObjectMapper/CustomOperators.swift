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

import Foundation
import UIKit

// MARK: NSData

/// Non Optional
public func <-> (inout left: NSData, right: SUMap) {
  left <-> (right, SUBase64Transform())
}
/// Optional
public func <-> (inout left: NSData?, right: SUMap) {
  left <-> (right, SUBase64Transform())
}
/// Implicitly Unwrapped Optional
public func <-> (inout left: NSData!, right: SUMap) {
  left <-> (right, SUBase64Transform())
}

// MARK: UIColor

/// Non Optional
public func <-> (inout left: UIColor, right: SUMap) {
  left <-> (right, SUColorTransform())
}
/// Optional
public func <-> (inout left: UIColor?, right: SUMap) {
  left <-> (right, SUColorTransform())
}
/// Implicitly Unwrapped Optional
public func <-> (inout left: UIColor!, right: SUMap) {
  left <-> (right, SUColorTransform())
}

// MARK: NSDate

/// Non Optional
public func <-> (inout left: NSDate, right: SUMap) {
  left <-> (right, SUISO8601DateTransform())
}
/// Optional
public func <-> (inout left: NSDate?, right: SUMap) {
  left <-> (right, SUISO8601DateTransform())
}
/// Implicitly Unwrapped Optional
public func <-> (inout left: NSDate!, right: SUMap) {
  left <-> (right, SUISO8601DateTransform())
}

// MARK: NSDecimalNumber

/// Non Optional
public func <-> (inout left: NSDecimalNumber, right: SUMap) {
  left <-> (right, SUDecimalNumberTransform())
}
/// Optional
public func <-> (inout left: NSDecimalNumber?, right: SUMap) {
  left <-> (right, SUDecimalNumberTransform())
}
/// Implicitly Unwrapped Optional
public func <-> (inout left: NSDecimalNumber!, right: SUMap) {
  left <-> (right, SUDecimalNumberTransform())
}

// MARK: NSURL

/// Non Optional
public func <-> (inout left: NSURL, right: SUMap) {
  left <-> (right, SUURLTransform())
}
/// Optional
public func <-> (inout left: NSURL?, right: SUMap) {
  left <-> (right, SUURLTransform())
}
/// Implicitly Unwrapped Optional
public func <-> (inout left: NSURL!, right: SUMap) {
  left <-> (right, SUURLTransform())
}
