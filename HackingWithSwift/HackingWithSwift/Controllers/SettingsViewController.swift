//
//  SettingsViewController.swift
//  HackingWithSwift
//
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - Vars

    var user: User!
    
    // MARK: - IBOutlets
    
    @IBOutlet var name: BoundTextField!
    @IBOutlet var projects: BoundSegmentedControl!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard user != nil else {
            assertionFailure("You must set a user before showing this view controller.")
            return
        }

        title = "Settings"
        
        setupBindings()
    }
    
    // MARK: - Private
    
    private func setupBindings() {
        name.bind(to: user.name)
        user.name.valueChanged = { [weak self] _ in
            self?.user.save()
        }
        
        projects.bind(to: user.showProjects)
        user.showProjects.valueChanged = { [weak self] _ in
            self?.user.save()
        }
    }
    
}
