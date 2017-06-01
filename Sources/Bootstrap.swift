
public extension Spaces {
  
  func prepare(completion: @escaping VoidOutputs) {
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

