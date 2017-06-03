
import Foundation

func dispatch_async_on_main(delay: TimeInterval? = nil, block: @escaping ()->()) {
  if let delay = delay {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
      block()
    }
  } else {
    DispatchQueue.main.async {
      block()
    }
  }
}
