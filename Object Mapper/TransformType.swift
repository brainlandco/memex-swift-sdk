
public protocol TransformType {
	associatedtype Object
	associatedtype JSON

	func transformFromJSON(_ value: Any?) -> Object?
	func transformToJSON(_ value: Object?) -> JSON?
}
