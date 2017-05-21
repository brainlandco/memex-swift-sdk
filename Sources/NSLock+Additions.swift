
import Foundation

extension NSLock {
  
  func withCriticalScope<T>(block: () -> T) -> T {
    self.lock()
    let value = block()
    self.unlock()
    return value
  }
  
}
