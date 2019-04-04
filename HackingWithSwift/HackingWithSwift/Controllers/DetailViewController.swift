//
//  DetailViewController.swift
//  HackingWithSwift
//
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, LoggerHandling {
    
    // MARK: - Vars
    
    var project: Project!
    
    // MARK: - Lifecycle
    
    override func loadView() {
        let detailView = DetailView(with: project) { [weak self] in
            self?.showReadVC()
        }
        view = detailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let project = project else {
            assertionFailure("You must set a project before showing this view controller.")
            return
        }

        navigationItem.largeTitleDisplayMode = .never
        title = "Project \(project.number)"
        log("Showed project \(project.number).")
    }
    
    // MARK: - Private
    
    private func showReadVC() {
        guard let readVC = storyboard?.instantiateViewController(withIdentifier: "ReadViewController") as? ReadViewController else {
            return
        }
        
        readVC.project = project
        navigationController?.pushViewController(readVC, animated: true)
    }
}
