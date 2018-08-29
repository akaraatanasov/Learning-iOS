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

import Foundation

struct Badge {
  let name: String
  let imageName: String
  let information: String
  let distance: Double
  
  init?(from dictionary: [String: String]) {
    guard
      let name = dictionary["name"],
      let imageName = dictionary["imageName"],
      let information = dictionary["information"],
      let distanceString = dictionary["distance"],
      let distance = Double(distanceString)
    else {
        return nil
    }
    self.name = name
    self.imageName = imageName
    self.information = information
    self.distance = distance
  }
  
  static let allBadges: [Badge] = {
    guard let fileURL = Bundle.main.url(forResource: "badges", withExtension: "txt") else {
      fatalError("No badges.txt file found")
    }
    do {
      let jsonData = try Data(contentsOf: fileURL, options: .mappedIfSafe)
      let jsonResult = try JSONSerialization.jsonObject(with: jsonData) as! [[String: String]]
      return jsonResult.compactMap(Badge.init)
    } catch {
      fatalError("Cannot decode badges.txt")
    }
  }()
  
  static func best(for distance: Double) -> Badge {
    return allBadges.filter { $0.distance < distance }.last ?? allBadges.first!
  }
  
  static func next(for distance: Double) -> Badge {
    return allBadges.filter { distance < $0.distance }.first ?? allBadges.last!
  }
}

// MARK: - Equatable

extension Badge: Equatable {
  static func ==(lhs: Badge, rhs: Badge) -> Bool {
    return lhs.name == rhs.name
  }
}
