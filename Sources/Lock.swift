
import Foundation


public class Lock {
  
  // MARK: Properties
  
  let semaphore: DispatchSemaphore
  
  // MARK: Lifecycle
  
  public init() {
    self.semaphore = DispatchSemaphore(value: 1)
  }
  
  // MARK: General
  
  public func lock() {
    let _ = self.semaphore.wait(timeout: DispatchTime.distantFuture)
  }
  
  public func unlock() {
    self.semaphore.signal()
  }
  
  public func withCriticalScope<T>(block: () -> T) -> T {
    self.lock()
    let value = block()
    self.unlock()
    return value
  }
  
  
  public func withCriticalScope(block: () -> ()) {
    self.lock()
    block()
    self.unlock()
  }
}
