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
import Foundation
import HealthKit
import WatchConnectivity

class InterfaceController: WKInterfaceController {
  
  // MARK: - Vars
  private let healthStore = HKHealthStore()
  private let wcSession = WCSession.default
  private var workoutSession: HKWorkoutSession?
  private var workoutConfiguration: HKWorkoutConfiguration?
  private var heartRateQuery: HKAnchoredObjectQuery?
  
  private var startButtonIsPressed = false
  
  var delegate: WorkoutSessionDelegate?
  
  // MARK: - IBOutlet
  @IBOutlet var distanceLabel: WKInterfaceLabel!
  @IBOutlet var timeLabel: WKInterfaceLabel!
  @IBOutlet var paceLabel: WKInterfaceLabel!
  @IBOutlet var heartRateLabel: WKInterfaceLabel!
  @IBOutlet var buttonOutlet: WKInterfaceButton!
  
  // MARK: - Lifecycle
  override func didAppear() {
    super.didAppear()
  
    if let extensionDelegate = WKExtension.shared().delegate as? ExtensionDelegate {
      extensionDelegate.delegate = self
    }
    
    NotificationCenter.default.addObserver(self, selector: #selector(phoneMessageReceived), name: NSNotification.Name(rawValue: "phoneMessageReceived"), object: nil)
  }
  
  // MARK: - Private
  @objc private func phoneMessageReceived(notification: Notification) {
    guard let message = notification.userInfo else {
      return
    }
    
    // Start/stop workout session
    if let workoutSessionWasStarted = message["startWorkoutSession"] as? Bool {
      startButtonIsPressed = workoutSessionWasStarted
      startWorkout(withState: workoutSessionWasStarted)
    }
    
    // Update display data
    if let updatedDisplayData = message as? [String : String] {
      updateDisplay(with: updatedDisplayData)
    }
    
  }
  
  private func startWorkoutSession() {
    guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate),
      let workoutConfiguration = workoutConfiguration else {
      return
    }
    
    do {
      workoutSession = try HKWorkoutSession(configuration: workoutConfiguration)
    } catch {
      print("Error: \(error.localizedDescription)")
    }
    
    let predicate = HKQuery.predicateForSamples(withStart: Date(), end: nil, options: [])
    heartRateQuery = HKAnchoredObjectQuery(type: heartRateType, predicate: predicate, anchor: nil, limit: Int(HKObjectQueryNoLimit)) { (query, samples, deletedObjects, anchor, error) in
      self.formatSamples(samples: samples)
    }
    
    if let heartRateQuery = heartRateQuery,
      let workoutSession = workoutSession {
      heartRateQuery.updateHandler = { (query, samples, deletedObjects, anchor, error) -> Void in
        self.formatSamples(samples: samples)
      }
      
      healthStore.start(workoutSession)
      healthStore.execute(heartRateQuery)
    }
  }
  
  private func stopWorkoutSession() {
    if let workoutSession = workoutSession, let heartRateQuery = heartRateQuery {
      healthStore.end(workoutSession)
      healthStore.stop(heartRateQuery)
    }
  }
  
  private func formatSamples(samples: [HKSample]?) {
    guard let samples = samples as? [HKQuantitySample] else { return }
    guard let quantity = samples.last?.quantity else { return }
    
    let heartRate = HKUnit(from: "count/min")
    let heartRateValue = Int(quantity.doubleValue(for: heartRate))
    print("HeartRate (watchOS): \(heartRateValue) BPM")
    DispatchQueue.main.async {
      self.heartRateLabel.setText("HeartRate: \(heartRateValue) BPM")
    }
    sendHeartRate(with: heartRateValue)
  }
  
  private func sendHeartRate(with heartRateValue: Int) {
    wcSession.sendMessage(["heartRate": heartRateValue], replyHandler: nil) { (error) in
      print("Error: \(error.localizedDescription)")
    }
  }
  
  private func startNewRun(withState runIsStarted: Bool) {
    wcSession.sendMessage(["startRun": runIsStarted], replyHandler: nil) { (error) in
      print("Error: \(error.localizedDescription)")
    }
    
    // This sends message to the iOS app to start a new run,
    // and when the run is started on the iOS app
    // it sends back a message to the watchOS app to
    // start the workout session. It works okay as it is, but if there
    // is no connection with the iOS app, the watchOS app will not
    // start the workout session, which means that the app
    // can't be used standalone without the iOS counterpart
  }
  
  private func startWorkout(withState workoutIsStarted: Bool) {
    if workoutIsStarted {
      DispatchQueue.main.async {
        self.distanceLabel.setText("Distance: -- km")
        self.timeLabel.setText("Time: 0:00:00")
        self.paceLabel.setText("Pace: -- min/km")
        self.heartRateLabel.setText("HeartRate: -- BPM")
        self.buttonOutlet.setTitle("Stop")
      }
      
      startWorkoutSession()
    } else {
      DispatchQueue.main.async {
        self.distanceLabel.setText("Distance: 0 km")
        self.timeLabel.setText("Time: 0:00:00")
        self.paceLabel.setText("Pace: 0 min/km")
        self.heartRateLabel.setText("HeartRate: 00 BPM")
        self.buttonOutlet.setTitle("Start")
      }
      
      stopWorkoutSession()
    }
  }
  
  private func updateDisplay(with displayData: [String : String]) {
    guard let distance = displayData["distance"],
      let time = displayData["time"],
      let pace = displayData["pace"] else {
        return
    }
    
    DispatchQueue.main.async {
      self.distanceLabel.setText("Distance: \(distance)")
      self.timeLabel.setText("Time: \(time)")
      self.paceLabel.setText("Pace: \(pace)")
    }
  }
  
  // MARK: - IBAction
  @IBAction func startButton() {
    startButtonIsPressed = !startButtonIsPressed
    startNewRun(withState: startButtonIsPressed)
  }

}

// MARK: - Workout Session Delegate
extension InterfaceController: WorkoutSessionDelegate {
  func pass(workoutConfiguration configuration: HKWorkoutConfiguration) {
    workoutConfiguration = configuration
  }
}
