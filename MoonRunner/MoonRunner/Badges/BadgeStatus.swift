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

struct BadgeStatus {
  let badge: Badge
  let earned: Run?
  let silver: Run?
  let gold: Run?
  let best: Run?
  
  static let silverMultiplier = 1.05
  static let goldMultiplier = 1.1
  
  static func badgesEarned(runs: [Run]) -> [BadgeStatus] {
    return Badge.allBadges.map { badge in
      var earned: Run?
      var silver: Run?
      var gold: Run?
      var best: Run?
      
      for run in runs where run.distance > badge.distance {
         if earned == nil {
          earned = run
        }
        
        let earnedSpeed = earned!.distance / Double(earned!.duration)
        let runSpeed = run.distance / Double(run.duration)
        
        if silver == nil && runSpeed > earnedSpeed * silverMultiplier {
          silver = run
        }
        
        if gold == nil && runSpeed > earnedSpeed * goldMultiplier {
          gold = run
        }
        
        if let existingBest = best {
          let bestSpeed = existingBest.distance / Double(existingBest.duration)
          if runSpeed > bestSpeed {
            best = run
          }
        } else {
          best = run
        }
      }
      
      return BadgeStatus(badge: badge, earned: earned, silver: silver, gold: gold, best: best)
    }
  }
}
