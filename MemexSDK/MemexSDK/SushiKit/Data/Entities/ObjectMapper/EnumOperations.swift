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

// MARK:- Raw Representable types

/// Object of Raw Representable type
public func <-> <T: RawRepresentable>(inout left: T, right: SUMap) {
  left <-> (right, SUEnumTransform())
}

/// Optional Object of Raw Representable type
public func <-> <T: RawRepresentable>(inout left: T?, right: SUMap) {
  left <-> (right, SUEnumTransform())
}

/// Implicitly Unwrapped Optional Object of Raw Representable type
public func <-> <T: RawRepresentable>(inout left: T!, right: SUMap) {
  left <-> (right, SUEnumTransform())
}

// MARK:- Arrays of Raw Representable type

/// Array of Raw Representable object
public func <-> <T: RawRepresentable>(inout left: [T], right: SUMap) {
  left <-> (right, SUEnumTransform())
}

/// Array of Raw Representable object
public func <-> <T: RawRepresentable>(inout left: [T]?, right: SUMap) {
  left <-> (right, SUEnumTransform())
}

/// Array of Raw Representable object
public func <-> <T: RawRepresentable>(inout left: [T]!, right: SUMap) {
  left <-> (right, SUEnumTransform())
}

// MARK:- Dictionaries of Raw Representable type

/// Dictionary of Raw Representable object
public func <-> <T: RawRepresentable>(inout left: [String: T], right: SUMap) {
  left <-> (right, SUEnumTransform())
}

/// Dictionary of Raw Representable object
public func <-> <T: RawRepresentable>(inout left: [String: T]?, right: SUMap) {
  left <-> (right, SUEnumTransform())
}

/// Dictionary of Raw Representable object
public func <-> <T: RawRepresentable>(inout left: [String: T]!, right: SUMap) {
  left <-> (right, SUEnumTransform())
}

