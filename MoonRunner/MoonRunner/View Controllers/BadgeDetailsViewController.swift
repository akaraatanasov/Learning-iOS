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

class BadgeDetailsViewController: UIViewController {
  
  @IBOutlet weak var badgeImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var earnedLabel: UILabel!
  @IBOutlet weak var bestLabel: UILabel!
  @IBOutlet weak var silverLabel: UILabel!
  @IBOutlet weak var goldLabel: UILabel!
  @IBOutlet weak var silverImageView: UIImageView!
  @IBOutlet weak var goldImageView: UIImageView!
  
  var status: BadgeStatus!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let badgeRotation = CGAffineTransform(rotationAngle: .pi / 8)
    
    badgeImageView.image = UIImage(named: status.badge.imageName)
    nameLabel.text = status.badge.name
    distanceLabel.text = FormatDisplay.distance(status.badge.distance)
    let earnedDate = FormatDisplay.date(status.earned?.timestamp)
    earnedLabel.text = "Reached on \(earnedDate)"
    
    let bestDistance = Measurement(value: status.best!.distance, unit: UnitLength.meters)
    let bestPace = FormatDisplay.pace(distance: bestDistance,
                                      seconds: Int(status.best!.duration),
                                      outputUnit: UnitSpeed.minutesPerKilometer)
    let bestDate = FormatDisplay.date(status.earned?.timestamp)
    bestLabel.text = "Best: \(bestPace), \(bestDate)"
    
    let earnedDistance = Measurement(value: status.earned!.distance, unit: UnitLength.meters)
    let earnedDuration = Int(status.earned!.duration)
    
    if let silver = status.silver {
      silverImageView.transform = badgeRotation
      silverImageView.alpha = 1
      let silverDate = FormatDisplay.date(silver.timestamp)
      silverLabel.text = "Earned on \(silverDate)"
    } else {
      silverImageView.alpha = 0
      let silverDistance = earnedDistance * BadgeStatus.silverMultiplier
      let pace = FormatDisplay.pace(distance: silverDistance,
                                    seconds: earnedDuration,
                                    outputUnit: UnitSpeed.minutesPerKilometer)
      silverLabel.text = "Pace < \(pace) for silver!"
    }
    
    if let gold = status.gold {
      goldImageView.transform = badgeRotation
      goldImageView.alpha = 1
      let goldDate = FormatDisplay.date(gold.timestamp)
      goldLabel.text = "Earned on \(goldDate)"
    } else {
      goldImageView.alpha = 0
      let goldDistance = earnedDistance * BadgeStatus.goldMultiplier
      let pace = FormatDisplay.pace(distance: goldDistance,
                                    seconds: earnedDuration,
                                    outputUnit: UnitSpeed.minutesPerKilometer)
      goldLabel.text = "Pace < \(pace) for gold!"
    }
  }
  
  @IBAction func infoButtonTapped() {
    let alert = UIAlertController(title: status.badge.name,
                                  message: status.badge.information,
                                  preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
    present(alert, animated: true)
  }
}
