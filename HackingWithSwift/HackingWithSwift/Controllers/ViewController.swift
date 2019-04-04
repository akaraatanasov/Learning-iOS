//
//  ViewController.swift
//  HackingWithSwift
//
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    // MARK: - Vars
    
    var user = User()
    var allProjects = [Project]()
    var showingProjects = [Project]()
    var dataSource = TableViewDataSource()
    
    weak var coordinator: MainCoordinator?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        loadProjects()
        updatePreferences()
    }

    // MARK: - Private
    
    private func setupView() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(showSettings))
    }
    
    private func loadProjects() {
        allProjects = Bundle.main.decode([Project].self, from: "projects")
    }
    
    private func updatePreferences() {
        title = user.name
        
        if user.showProjects == 0 {
            // show all projects
            showingProjects = allProjects
        } else {
            // show only the project types they selected
            showingProjects = allProjects.filter { $0.number % 3 == user.showProjects - 1 }
        }
        
        dataSource = TableViewDataSource(with: showingProjects)
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
    
    @objc private func showSettings() {
        coordinator?.showSettingsViewController(with: user, from: self)
    }
    
    // MARK: - Public
    
    func updateUser(_ newUser: User) {
        user = newUser
        user.save()
        updatePreferences()
    }
    
    // MARK: - Table View Delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let project = showingProjects[indexPath.row]
        coordinator?.showDetailViewController(with: project)
    }
    
}

// MARK: - Bundle Decoder Extension

extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from file: String) -> T {
        guard let url = Bundle.main.url(forResource: file, withExtension: "json") else {
            fatalError("Failed to locate \(file).json in app bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file).json in app bundle.")
        }

        guard let loadedProjects = try? JSONDecoder().decode(T.self, from: data) else {
            fatalError("Failed to decode projects.json from app bundle.")
        }
        
        return loadedProjects
    }
}
