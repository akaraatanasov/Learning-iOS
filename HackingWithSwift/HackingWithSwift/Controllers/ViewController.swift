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
        guard let url = Bundle.main.url(forResource: "projects", withExtension: "json") else {
            fatalError("Failed to locate projects.json in app bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load projects.json in app bundle.")
        }
        
        let decoder = JSONDecoder()
        
        guard let loadedProjects = try? decoder.decode([Project].self, from: data) else {
            fatalError("Failed to decode projects.json from app bundle.")
        }
        
        allProjects = loadedProjects
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
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController else {
            fatalError("Unable to find SettingsViewController")
        }
        
        vc.delegate = self
        vc.user = user
        navigationController?.pushViewController(vc, animated: true)
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

        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
            return
        }

        detailVC.project = project
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}