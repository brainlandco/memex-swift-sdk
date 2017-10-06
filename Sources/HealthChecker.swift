import Foundation
import Reachability

class HealthChecker: NSObject {
  
  // MARK: Types
  
  typealias Callback = (_ offline: Bool, _ maintanance: Bool)->()
  
  // MARK: Data
  
  private let observedURL: URL!
  private let didChangeState: Callback
  private var attemptsCount = 0
  private var lock = Lock()
  private var reachability: Reachability!
  var offline: Bool = false
  var maintanance: Bool = false
  private var maintananceObserverActive = false
  var timerToken: Date?
  
  // MARK: Lifecycle
  
  init(URL: URL!, didChangeState: @escaping Callback) {
    self.observedURL = URL
    self.didChangeState = didChangeState
    super.init()
    self.startReachabilityObserver()
  }
  
  // MARK: General
  
  func startReachabilityObserver() {
    do {
      self.reachability = Reachability(hostname: self.observedURL.host!)
      self.reachability.whenReachable = { reachability in
        self.lock.withCriticalScope(block: {
          self.offline = false
          self.notify()
        })
      }
      self.reachability.whenUnreachable = { reachability in
        self.lock.withCriticalScope(block: {
          self.offline = true
          self.notify()
        })
      }
      try self.reachability.startNotifier()
    } catch {
      NSLog("Unable to setup Reachability")
    }
  }
  
  func notify() {
    self.didChangeState(self.offline, self.maintanance)
  }
  
  func observedEnabledMaintanance() {
    self.lock.withCriticalScope(block: {
      self.maintanance = true
    })
  }
  
  func startMaintananceObserver(restart: Bool = false) {
    self.lock.withCriticalScope(block: {
      if self.maintananceObserverActive == true && restart == false {
        return
      }
      self.attemptsCount = 0
      self.stopMaintananceObserverInternal()
      self.maintananceObserverActive = true
      self.scheduleNextAttempt()
    })
  }
  
  func stopMaintananceObserver() {
    self.lock.withCriticalScope {
      self.stopMaintananceObserverInternal()
    }
  }
  
  private func stopMaintananceObserverInternal() {
    self.timerToken = nil
    self.attemptsCount = 0
    self.maintananceObserverActive = false
  }
  
  func checkMaintanance() {
    NSLog("Will check maintanance status (attempt: \(self.attemptsCount))")
    let task = URLSession.shared.dataTask(with: self.observedURL) { (data, response, error) in
      self.lock.withCriticalScope(block: {
        if error == nil {
          if let httpResponse = response as? HTTPURLResponse {
            let newMaintanance = httpResponse.statusCode == 503
            if newMaintanance != self.maintanance {
              self.maintanance = newMaintanance
              self.notify()
            }
          }
        }
        if self.maintanance == false {
          self.stopMaintananceObserverInternal()
        } else {
          self.attemptsCount += 1
          self.scheduleNextAttempt()
        }
      })
    }
    task.resume()
  }
  
  private func scheduleNextAttempt() {
    let delay = self.nextAttemptDelay()
    let token = Date()
    self.timerToken = token
    dispatch_async_on_main(delay: delay) { [weak self] in
      guard let strongSelf = self else { return }
      guard strongSelf.timerToken == token else { return }
      self?.checkMaintanance()
    }
  }
  
  private func nextAttemptDelay() -> TimeInterval {
    return TimeInterval(self.attemptsCount^4 + 15 + ((Int(arc4random()) % 30) * (self.attemptsCount + 1)))
  }
  
}

