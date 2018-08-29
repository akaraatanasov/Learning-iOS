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

class InterfaceController: WKInterfaceController {

  // MARK: - Vars
  private let healthStore = HKHealthStore()
  private var configuration: HKWorkoutConfiguration!
  private var session: HKWorkoutSession!
  
  var startButtonIsPressed = false
  
  // MARK: - IBOutlet
  @IBOutlet var heartRateLabel: WKInterfaceLabel!
  @IBOutlet var buttonOutlet: WKInterfaceButton!
  
  // MARK: - Lifecycle
  override func didAppear() {
    super.didAppear()
    
    healthStoreAuthorization()
  }
  
  // MARK: - Private
  private func healthStoreAuthorization() {
    let typesToShare: Set = [
      HKQuantityType.workoutType()
    ]
    
    let typesToRead: Set = [
      HKQuantityType.quantityType(forIdentifier: .heartRate)!
    ]
    
    healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
      // Handle error
    }
  }
  
  private func setupWorkoutSession() {
  
  }
  
  private func startWorkoutSession() {
  
  }
  
  // MARK: - IBAciton
  @IBAction func startButton() {
    startButtonIsPressed = !startButtonIsPressed
    
    if startButtonIsPressed {
      buttonOutlet.setTitle("Stop")
      
      heartRateLabel.setText("HeartRate: --- BPM")
    
    
    } else {
      buttonOutlet.setTitle("Start")
      heartRateLabel.setText("HeartRate: 00 BPM")
    
    
    }
  }

}
