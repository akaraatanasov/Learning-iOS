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
import CoreData

class BadgesTableViewController: UITableViewController {
  
  var statusList: [BadgeStatus]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    statusList = BadgeStatus.badgesEarned(runs: getRuns())
  }
  
  private func getRuns() -> [Run] {
    let fetchRequest: NSFetchRequest<Run> = Run.fetchRequest()
    let sortDescriptor = NSSortDescriptor(key: #keyPath(Run.timestamp), ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]
    do {
      return try CoreDataStack.context.fetch(fetchRequest)
    } catch {
      return []
    }
  }
}

// MARK: - Table View Data Source

extension BadgesTableViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return statusList.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: BadgeCell = tableView.dequeueReusableCell(for: indexPath)
    cell.status = statusList[indexPath.row]
    return cell
  }
}

// MARK: - Navigation

extension BadgesTableViewController: SegueHandlerType {
  enum SegueIdentifier: String {
    case details = "BadgeDetailsViewController"
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segueIdentifier(for: segue) {
    case .details:
      let destination = segue.destination as! BadgeDetailsViewController
      let indexPath = tableView.indexPathForSelectedRow!
      destination.status = statusList[indexPath.row]
    }
  }
  
  override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    guard let segue = SegueIdentifier(rawValue: identifier) else { return false }
    switch segue {
    case .details:
      guard let cell = sender as? UITableViewCell else { return false }
      return cell.accessoryType == .disclosureIndicator
    }
  }
}
