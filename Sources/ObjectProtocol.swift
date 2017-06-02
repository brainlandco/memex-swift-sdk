
import Foundation
import ObjectMapper

/// Defines shared protocol for media, spaces and links
public protocol ObjectProtocol: Hashable {
  var MUID: String? { get }
  var updatedAt: Date? { get }
}

