
import Foundation


class Lock {
  
  // MARK: Properties
  
  let semaphore: DispatchSemaphore
  
  // MARK: Lifecycle
  
  init() {
    self.semaphore = DispatchSemaphore(value: 1)
  }
  
  // MARK: General
  
  func lock() {
    let _ = self.semaphore.wait(timeout: DispatchTime.distantFuture)
  }
  
  func unlock() {
    self.semaphore.signal()
  }
  
  func withCriticalScope<T>(block: () -> T) -> T {
    self.lock()
    let value = block()
    self.unlock()
    return value
  }
  
  func withCriticalScope(block: () -> ()) {
    self.lock()
    block()
    self.unlock()
  }
}
