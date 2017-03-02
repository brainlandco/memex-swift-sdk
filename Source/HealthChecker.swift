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
import ReachabilitySwift

class SUServiceHealthChecker: NSObject {
  
  // MARK: Types
  
  typealias Callback = (offline: Bool, maintanance: Bool)->()
  
  // MARK: Data
  
  private let observedURL: NSURL!
  private let didChangeState: Callback
  private var attemptsCount = 0
  private var lock = ATLock()
  private var reachability: Reachability!
  var offline: Bool = false
  var maintanance: Bool = false
  private var maintananceObserverActive = false
  var timerToken: AnyObject?
  
  // MARK: Lifecycle
  
  init(URL: NSURL!, didChangeState: Callback) {
    self.observedURL = URL
    self.didChangeState = didChangeState
    super.init()
    self.startReachabilityObserver()
  }
  
  // MARK: General
  
  func startReachabilityObserver() {
    do {
      self.reachability = try Reachability(hostname: self.observedURL.host!)
      self.reachability.whenReachable = { reachability in
        self.lock.withCriticalScope({
          self.offline = false
          self.notify()
        })
      }
      self.reachability.whenUnreachable = { reachability in
        self.lock.withCriticalScope({
          self.offline = true
          self.notify()
        })
      }
      try self.reachability.startNotifier()
    } catch {
      print("Unable to setup Reachability")
    }
  }
  
  func notify() {
    self.didChangeState(offline: self.offline, maintanance: self.maintanance)
  }
  
  func observedEnabledMaintanance() {
    self.lock.withCriticalScope({
      self.maintanance = true
    })
  }
  
  func startMaintananceObserver(restart restart: Bool = false) {
    self.lock.withCriticalScope({
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
    print("Will check maintanance status (attempt: \(self.attemptsCount))")
    let task = NSURLSession.sharedSession().dataTaskWithURL(self.observedURL) { (data, response, error) in
      self.lock.withCriticalScope({
        if error == nil {
          if let httpResponse = response as? NSHTTPURLResponse {
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
    let token = NSDate()
    self.timerToken = token
    dispatch_async_on_main(delay: delay) { [weak self] in
      guard let strongSelf = self else { return }
      guard strongSelf.timerToken === token else { return }
      self?.checkMaintanance()
    }
  }
  
  private func nextAttemptDelay() -> NSTimeInterval {
    return NSTimeInterval(self.attemptsCount^4 + 15 + ((Int(arc4random()) % 30) * (self.attemptsCount + 1)))
  }
  
}

