//
//  MainCoordinator.swift
//  HackingWithSwift
//
//  Created by Alexander Karaatanasov on 4.04.19.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import UIKit

class MainCoordinator {
    
    // MARK: - Vars
    
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    var navigationController: UINavigationController
    
    // MARK: - Inits
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Public
    
    func start() {
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController else {
            fatalError("Unable to find ViewController")
        }
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showSettingsViewController(with user: User, from viewController: ViewController) {
        guard let settingsViewController = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController else {
            fatalError("Unable to find SettingsViewController")
        }
        settingsViewController.user = user
        settingsViewController.delegate = viewController
        navigationController.pushViewController(settingsViewController, animated: true)
    }
    
    func showDetailViewController(with project: Project) {
        guard let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
            fatalError("Unable to find DetailViewController")
        }
//        let detailViewController = DetailViewController()
        detailViewController.project = project
        detailViewController.coordinator = self
        navigationController.pushViewController(detailViewController, animated: true)
    }
    
    func showReadViewController(with project: Project) {
        guard let readViewController = storyboard.instantiateViewController(withIdentifier: "ReadViewController") as? ReadViewController else {
            fatalError("Unable to find ReadViewController")
        }
        readViewController.project = project
        navigationController.pushViewController(readViewController, animated: true)
    }
    
}
