//
//  SettingsViewController.swift
//  HackingWithSwift
//
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet var name: UITextField!
    @IBOutlet var projects: UISegmentedControl!

    weak var delegate: ViewController?
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard user != nil else {
            assertionFailure("You must set a user before showing this view controller.")
            return
        }

        title = "Settings"
        name.text = user.name
        projects.selectedSegmentIndex = user.showProjects
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        delegate?.updateUser(user)
    }

    @IBAction func nameChanged(_ sender: UITextField) {
        user?.name = sender.text ?? ""
    }

    @IBAction func projectsChanged(_ sender: UISegmentedControl) {
        user?.showProjects = sender.selectedSegmentIndex
    }
}
