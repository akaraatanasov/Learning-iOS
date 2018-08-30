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

import UIKit
import HealthKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  let healthStore = HKHealthStore()
  let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)! // REMOVE force-unwrap
  
  // MARK: - Lifecycle
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    UINavigationBar.appearance().tintColor = .white
    UINavigationBar.appearance().barTintColor = .black
    
    let locationManager = LocationManager.shared
    locationManager.requestWhenInUseAuthorization()
    
    authorizeHealthKit { (authorized,  error) -> Void in
      if authorized {
        print("HealthKit authorization received.")
      } else {
        print("HealthKit authorization denied!")
        
        if let error = error {
          print("Error: \(error.localizedDescription)")
        }
      }
    }
    
    return true
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    CoreDataStack.saveContext()
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    CoreDataStack.saveContext()
  }
  
  // MARK: - Private
  
  private func authorizeHealthKit(completion: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
    guard HKHealthStore.isHealthDataAvailable() else {
      let error = NSError(domain: "com.appolica.MoonRunner", code: 2, userInfo: [NSLocalizedDescriptionKey : "HealthKit is not available in this Device"])
      completion(false, error)
      
      return
    }
    
    // probably should if let them all ?!?
    let typesToShare: Set = [
      HKQuantityType.quantityType(forIdentifier: .bodyMassIndex)!,
      HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
      HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
      HKQuantityType.workoutType()
    ]
    
    let typesToRead: Set = [
      HKQuantityType.characteristicType(forIdentifier: .dateOfBirth)!,
      HKQuantityType.characteristicType(forIdentifier: .bloodType)!,
      HKQuantityType.characteristicType(forIdentifier: .biologicalSex)!,
      HKQuantityType.quantityType(forIdentifier: .bodyMass)!,
      HKQuantityType.quantityType(forIdentifier: .height)!,
      HKQuantityType.quantityType(forIdentifier: .heartRate)!,
      HKQuantityType.workoutType()
    ]
    
    healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
      DispatchQueue.main.async {
        self.enableBackgroundDelivery(for: self.heartRateType)
      }
        
      completion(success, nil)
    }
  }
  
  private func enableBackgroundDelivery(for type: HKQuantityType) {
    healthStore.enableBackgroundDelivery(for: type, frequency: .immediate) { (success, error) in
      if success {
        print("Enabled background delivery of heart rate changes")
      } else {
        if let error = error {
          print("Failed to enable background delivery of heart rate changes. ")
          print("Error = \(error.localizedDescription)")
        }
      }
    }
  }
  
  
}

