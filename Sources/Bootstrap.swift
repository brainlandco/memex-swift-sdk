
public extension Spaces {
  
  
  /**
   This method needs to be called before any other request. So Memex SDK should look like this.
   ```
   let memex = new Memex("<Your app token>")
   memex.prepare() { error in
    guard error == nil else {
      // setup failed
    }
    // make your requests here
   }
   
   ```
   
   - parameter completion: Completion block that returns error if something wrong happens.
   
   */
  public func prepare(completion: @escaping VoidOutputs) {
    if self.healthChecker == nil {
      self.healthChecker = HealthChecker(URL: self.configuration.serverURL,
                                         didChangeState: { [weak self] offline, maintanance in
                                          self?.emit(event: ConnectionHealthChangedEvent(offline: offline, maintanance: maintanance))
      })
    } else {
      self.healthChecker.startMaintananceObserver(restart: true)
    }
    self.auth.bootstrap() {
      completion(nil)
    }
  }
  
}

