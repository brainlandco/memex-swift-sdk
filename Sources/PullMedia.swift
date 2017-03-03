/**
 *
 * Copyright (c) 2016, Adam Zdara.
 * Created by: Adam Zdara on 12/06/16
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

import Foundation
import Sushi
import ObjectMapper

public extension Memex {
  
  public class Inputs: OPVoidOperationParameters {
    public var lastModelVersion: Int?
    public var offset: Int?
  }
  
  public class Outputs: OPVoidOperationResults {
    public var items: [RMMedia]!
    public var modelVersion: Int!
    public var totalItems: Int!
    public var hasMore: Bool!
    public var nextOffset: Int!
  }
  
  public class Operation: RMOperation<Inputs, Outputs> {
    
    public init(lastModelVersion: Int?,
                offset: Int?,
                module: OPModuleProtocol? = nil) {
      super.init(module: module)
      self.parameters.lastModelVersion = lastModelVersion
      self.parameters.offset = offset
    }
    
    override public func execute() {
      var parameters = [String: AnyObject]()
      if let value = self.parameters.lastModelVersion {
        parameters["last_model_version"] = value
      }
      if let value = self.parameters.offset {
        parameters["offset"] = value
      }
      GET("users/self/media",
          parameters: parameters) { [weak self] response in
              self?.results.items = self?.entitiesFromArray(response.data)
              self?.results.modelVersion = response.metadata?["model_version"] as? Int
              self?.results.totalItems = response.metadata?["total"] as? Int
              self?.results.hasMore = response.metadata?["has_more"] as? Bool
              self?.results.nextOffset = response.metadata?["next_offset"] as? Int
      }
    }
  }
  
}



