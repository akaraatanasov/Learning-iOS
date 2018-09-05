//
/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import WatchKit
import HealthKit
import WatchConnectivity

protocol WorkoutSessionDelegate: class {
  func pass(workoutConfiguration configuration: HKWorkoutConfiguration)
}

class ExtensionDelegate: NSObject {
  
  // MARK: - Vars
  private let healthStore = HKHealthStore()
  private let wcSession = WCSession.isSupported() ? WCSession.default : nil
  
  weak var delegate: WorkoutSessionDelegate?
  
  // MARK: - Lifecycle
  func applicationDidFinishLaunching() {
    healthStoreAuthorization()
    setupWatchConnectivity()
  }
  
  func applicationDidBecomeActive() {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillResignActive() {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, etc.
  }
  
  func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
    // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
    for task in backgroundTasks {
      // Use a switch statement to check the task type
      switch task {
      case let backgroundTask as WKApplicationRefreshBackgroundTask:
        // Be sure to complete the background task once you’re done.
        backgroundTask.setTaskCompletedWithSnapshot(false)
      case let snapshotTask as WKSnapshotRefreshBackgroundTask:
        // Snapshot tasks have a unique completion call, make sure to set your expiration date
        snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
      case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
        // Be sure to complete the connectivity task once you’re done.
        connectivityTask.setTaskCompletedWithSnapshot(false)
      case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
        // Be sure to complete the URL session task once you’re done.
        urlSessionTask.setTaskCompletedWithSnapshot(false)
      default:
        // make sure to complete unhandled task types
        task.setTaskCompletedWithSnapshot(false)
      }
    }
  }
  
  // MARK: - Private
  private func healthStoreAuthorization() {
    guard let heartRate = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
      return
    }
    
    let typesToShare: Set = [ HKQuantityType.workoutType() ]
    let typesToRead: Set = [ heartRate ]
    
    healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
      if let theError = error {
        print("Error: \(theError.localizedDescription)")
      }
    }
  }
  
  private func setupWatchConnectivity() {
    wcSession?.delegate = self
    wcSession?.activate()
  }
  
}

// MARK: - WKExtensionDelegate
extension ExtensionDelegate: WKExtensionDelegate {
  func handle(_ workoutConfiguration: HKWorkoutConfiguration) {
    delegate?.pass(workoutConfiguration: workoutConfiguration)
  }
}

// MARK: - Watch Conectivity Session Delegate
extension ExtensionDelegate: WCSessionDelegate {
  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    var stateToPrint = ""
    
    switch activationState {
    case .notActivated: stateToPrint = ".notActivated"
    case .inactive: stateToPrint = ".inactive"
    case .activated: stateToPrint = ".activated"
    }
    
    print("Watch Connectivity session activation completed with state: \(stateToPrint)")
  }
  
  func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "phoneMessageReceived"), object: self, userInfo: message)
  }
}
