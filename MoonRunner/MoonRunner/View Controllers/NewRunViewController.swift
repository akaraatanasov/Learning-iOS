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
import MapKit
import HealthKit
import CoreLocation
import AVFoundation
import WatchConnectivity

class NewRunViewController: UIViewController {
  
  // MARK: - IBOutlets
  @IBOutlet weak var launchPromptStackView: UIStackView!
  
  @IBOutlet weak var dataStackView: UIStackView!
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var paceLabel: UILabel!
  @IBOutlet weak var heartRateLabel: UILabel!
  
  @IBOutlet weak var mapContainerView: UIView!
  @IBOutlet weak var mapView: MKMapView!
  
  @IBOutlet weak var badgeStackView: UIStackView!
  @IBOutlet weak var badgeImageView: UIImageView!
  @IBOutlet weak var badgeInfoLabel: UILabel!
  
  @IBOutlet weak var startButton: UIButton!
  @IBOutlet weak var stopButton: UIButton!
  
  // MARK: - Vars
  private var run: Run?
  private let locationManager = LocationManager.shared
  private var seconds = 0
  private var timer: Timer?
  private var distance = Measurement(value: 0, unit: UnitLength.meters)
  private var locationList: [CLLocation] = [] {
    didSet {
      if let lastLocation = locationList.last {
        print("Lat: \(lastLocation.coordinate.latitude), Lon: \(lastLocation.coordinate.longitude), Time: \(lastLocation.timestamp)")
      }
    }
  }
  private var heartRateList: [Int] = [] {
    didSet {
      if let lastHeartBeat = heartRateList.last {
        print("BPM: \(lastHeartBeat), Time: \(Date().description)")
      }
    }
  }
  
  private var upcomingBadge: Badge!
  private let successSound: AVAudioPlayer = {
    guard let successSound = NSDataAsset(name: "success") else {
      return AVAudioPlayer()
    }
    
    return try! AVAudioPlayer(data: successSound.data)
  }()
  
  private let wcSession = WCSession.default
  private let healthStore = HKHealthStore()
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    dataStackView.isHidden = true
    badgeStackView.isHidden = true
    
    NotificationCenter.default.addObserver(self, selector: #selector(watchMessageReceived), name: NSNotification.Name(rawValue: "watchMessageReceived"), object: nil)
    startWatchApp(withActivity: .running, andLocation: .unknown)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    timer?.invalidate()
    locationManager.stopUpdatingLocation()
    manageWatchWorkoutSession(startWorkout: false)
  }
  
  // MARK: - Private
  @objc private func watchMessageReceived(notification: Notification) {
    guard let message = notification.userInfo else {
      return
    }
    
    // Heart rate messages
    if let heartRateValue = message["heartRate"] as? Int {
      heartRateList.append(heartRateValue)
    }
    
    // Start/stop run
    if let startNewRun = message["startRun"] as? Bool {
      DispatchQueue.main.async {
        startNewRun ? self.startRun() : self.stopTapped()
      }
    }
    
  }
  
  private func startWatchApp(withActivity activity: HKWorkoutActivityType, andLocation location: HKWorkoutSessionLocationType) {
    let workoutConfiguration = HKWorkoutConfiguration()
    
    workoutConfiguration.activityType = activity
    workoutConfiguration.locationType = location
    
    healthStore.startWatchApp(with: workoutConfiguration) { (success, error) in
      print ("Watch App launched successfully: \(success)")
      
      if let theError = error {
        print("Error: \(theError.localizedDescription)")
      }
    }
    
  }
  
  private func manageWatchWorkoutSession(startWorkout message: Bool) {
    wcSession.sendMessage(["startWorkoutSession" : message], replyHandler: nil) { (error) in
        print("Error: \(error.localizedDescription)")
    }
  }

  private func startRun() {
    launchPromptStackView.isHidden = true
    dataStackView.isHidden = false
    startButton.isHidden = true
    stopButton.isHidden = false
    mapContainerView.isHidden = false
    mapView.removeOverlays(mapView.overlays)
    
    seconds = 0
    distance = Measurement(value: 0, unit: UnitLength.meters)
    locationList.removeAll()
    
    badgeStackView.isHidden = false
    upcomingBadge = Badge.next(for: 0)
    badgeImageView.image = UIImage(named: upcomingBadge.imageName)
    
    updateDisplay()
    
    DispatchQueue.main.async {
      self.heartRateLabel.text = "HeartRate: -- BPM"
    }
    
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
      self.eachSecond()
    }
    startLocationUpdates()
    manageWatchWorkoutSession(startWorkout: true)
  }
  
  private func stopRun() {
    launchPromptStackView.isHidden = false
    dataStackView.isHidden = true
    startButton.isHidden = false
    stopButton.isHidden = true
    mapContainerView.isHidden = true
    badgeStackView.isHidden = true
    
    locationManager.stopUpdatingLocation()
    manageWatchWorkoutSession(startWorkout: false)
  }
  
  private func eachSecond() {
    seconds += 1
    checkNextBadge()
    updateWatchDisplay(distance: FormatDisplay.distance(distance), time: FormatDisplay.time(seconds), pace: FormatDisplay.pace(distance: distance,
                                                                                                                               seconds: seconds,
                                                                                                                               outputUnit: UnitSpeed.minutesPerKilometer))
    updateDisplay()
  }
  
  private func updateDisplay() {
    let formattedDistance = FormatDisplay.distance(distance)
    let formattedTime = FormatDisplay.time(seconds)
    let formattedPace = FormatDisplay.pace(distance: distance,
                                           seconds: seconds,
                                           outputUnit: UnitSpeed.minutesPerKilometer)
    
    distanceLabel.text = "Distance:  \(formattedDistance)"
    timeLabel.text = "Time:  \(formattedTime)"
    paceLabel.text = "Pace:  \(formattedPace)"
    
//    updateWatchDisplay(distance: formattedDistance, time: formattedTime, pace: formattedPace)
    
    if let heartRate = heartRateList.last {
      self.heartRateLabel.text = "HeartRate: \(heartRate) BPM"
    }
    
    let distanceRemaining = upcomingBadge.distance - distance.value
    let formattedDistanceRemaining = FormatDisplay.distance(distanceRemaining)
    badgeInfoLabel.text = "\(formattedDistanceRemaining) until \(upcomingBadge.name)"
  }
  
  private func updateWatchDisplay(distance formattedDistance: String, time formattedTime: String, pace formattedPace: String) {
    let updatedDisplayData = [ "distance" : formattedDistance, "time" : formattedTime, "pace" : formattedPace ]
    wcSession.sendMessage(updatedDisplayData, replyHandler: nil) { (error) in
      print("Error: \(error.localizedDescription)")
    }
  }
  
  private func startLocationUpdates() {
    locationManager.delegate = self
    locationManager.activityType = .fitness
    locationManager.distanceFilter = 10
    locationManager.startUpdatingLocation()
  }
  
  private func saveRun() {
    let newRun = Run(context: CoreDataStack.context)
    newRun.distance = distance.value
    newRun.duration = Int16(seconds)
    newRun.timestamp = Date()
    
    for location in locationList {
      let locationObject = Location(context: CoreDataStack.context)
      locationObject.timestamp = location.timestamp
      locationObject.latitude = location.coordinate.latitude
      locationObject.longitude = location.coordinate.longitude
      newRun.addToLocations(locationObject)
    }
    
    CoreDataStack.saveContext()
    // save heart rate shit
    run = newRun
  }
  
  private func checkNextBadge() {
    let nextBadge = Badge.next(for: distance.value)
    if upcomingBadge != nextBadge {
      badgeImageView.image = UIImage(named: nextBadge.imageName)
      upcomingBadge = nextBadge
      successSound.play()
      AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
  }
  
  // MARK: - IBActions
  @IBAction func startTapped() {
    startRun()
  }
  
  @IBAction func stopTapped() {
    let alertController = UIAlertController(title: "End run?",
                                            message: "Do you wish to end your run?",
                                            preferredStyle: .actionSheet)
    
    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    
    alertController.addAction(UIAlertAction(title: "Save", style: .default) { _ in
      self.stopRun()
      self.saveRun()
      self.performSegue(withIdentifier: .details, sender: nil)
    })
    
    alertController.addAction(UIAlertAction(title: "Discard", style: .destructive) { _ in
      self.stopRun()
      _ = self.navigationController?.popToRootViewController(animated: true)
    })
    
    present(alertController, animated: true)
  }
  
}

// MARK: - Navigation
extension NewRunViewController: SegueHandlerType {
  enum SegueIdentifier: String {
    case details = "RunDetailsViewController"
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segueIdentifier(for: segue) {
    case .details:
      let destination = segue.destination as! RunDetailsViewController
      destination.run = run
      // add heart rate
    }
  }
}

// MARK: - Location Manager Delegate
extension NewRunViewController: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    for newLocation in locations {
      let howRecent = newLocation.timestamp.timeIntervalSinceNow
      guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
      
      if let lastLocation = locationList.last {
        let delta = newLocation.distance(from: lastLocation)
        distance = distance + Measurement(value: delta, unit: UnitLength.meters)
        
        let coordinates = [lastLocation.coordinate, newLocation.coordinate]
        mapView.add(MKPolyline(coordinates: coordinates, count: 2))
        
        let region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 500, 500)
        mapView.setRegion(region, animated: true)
      }
      
      locationList.append(newLocation)
    }
  }
}

// MARK: - Map View Delegate
extension NewRunViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    guard let polyline = overlay as? MKPolyline else {
      return MKOverlayRenderer(overlay: overlay)
    }
    
    let renderer = MKPolylineRenderer(polyline: polyline)
    renderer.strokeColor = .blue
    renderer.lineWidth = 3
    return renderer
  }
}
