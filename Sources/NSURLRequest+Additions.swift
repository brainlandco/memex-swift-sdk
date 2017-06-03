
import Foundation

extension URLRequest {
  
  func toCURL() -> String {
    var command = "curl -i -v -L "
    command += "-X \(self.httpMethod!) "
    if self.httpMethod == "PUT" || self.httpMethod == "POST" {
      if let body = self.httpBody, let encodedBody = NSString(data: body, encoding: String.Encoding.utf8.rawValue) {
        command += "--data '\(encodedBody)' "
      }
    }
    for (key, value) in self.allHTTPHeaderFields! {
      command += "--header '\(key): \(value)' "
    }
    command += "\"\(self.url!.absoluteString)\""
    return command
  }
  
}

