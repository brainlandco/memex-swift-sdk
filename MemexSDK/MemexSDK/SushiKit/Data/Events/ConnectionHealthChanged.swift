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

public class ConnectionHealthChangedEvent: OPEvent {
  
  public let offline: Bool
  public let maintanance: Bool
  
  init(offline: Bool, maintanance: Bool) {
    self.offline = offline
    self.maintanance = maintanance
  }
  
}
