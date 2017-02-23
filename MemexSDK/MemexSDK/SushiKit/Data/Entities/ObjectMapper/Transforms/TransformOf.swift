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

public class TransformOf<ObjectType, JSONType>: SUTransformType {
  
	public typealias Object = ObjectType
	public typealias JSON = JSONType
  
	private let fromJSON: JSONType? -> ObjectType?
	private let toJSON: ObjectType? -> JSONType?

	public init(fromJSON: JSONType? -> ObjectType?, toJSON: ObjectType? -> JSONType?) {
		self.fromJSON = fromJSON
		self.toJSON = toJSON
	}

	public func transformFromJSON(value: AnyObject?) -> ObjectType? {
		return fromJSON(value as? JSONType)
	}

	public func transformToJSON(value: ObjectType?) -> JSONType? {
		return toJSON(value)
	}
}
