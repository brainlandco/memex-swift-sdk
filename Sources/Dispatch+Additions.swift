
import Foundation

public func dispatch_async_on_main(delay: TimeInterval? = nil, block: @escaping ()->()) {
  if let delay = delay {
    let time = DispatchTime.init(uptimeNanoseconds: UInt64(delay * Double(NSEC_PER_SEC)))
    DispatchQueue.main.asyncAfter(deadline: time) {
      block()
    }
  } else {
    DispatchQueue.main.async {
      block()
    }
  }
}
