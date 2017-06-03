
import Foundation
import ObjectMapper

class URLTransform: TransformType {
  
	typealias Object = URL
	typealias JSON = String

	init() {}

	func transformFromJSON(_ value: Any?) -> URL? {
		if let URLString = value as? String {
			return URL(string: URLString)
		}
		return nil
	}

	func transformToJSON(_ value: URL?) -> String? {
		if let URL = value {
			return URL.absoluteString
		}
		return nil
	}
}
