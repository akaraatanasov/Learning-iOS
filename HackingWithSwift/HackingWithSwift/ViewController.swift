//
//  ViewController.swift
//  HackingWithSwift
//
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var allProjects = [Project]()
    var showingProjects = [Project]()
    var user = User()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(showSettings))

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
        updatePreferences()
    }

    @objc func showSettings() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController else {
            fatalError("Unable to find SettingsViewController")
        }

        vc.delegate = self
        vc.user = user
        navigationController?.pushViewController(vc, animated: true)
    }

    func updateUser(_ newUser: User) {
        user = newUser
        user.save()
        updatePreferences()
    }

    func updatePreferences() {
        title = user.name

        if user.showProjects == 0 {
            // show all projects
            showingProjects = allProjects
        } else {
            // show only the project types they selected
            showingProjects = allProjects.filter {
                $0.number % 3 == user.showProjects - 1
            }
        }

        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showingProjects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let project = showingProjects[indexPath.row]
        cell.textLabel?.attributedText = makeAttributedString(title: project.title, subtitle: project.subtitle)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let project = showingProjects[indexPath.row]

        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
            return
        }

        detailVC.project = project
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func makeAttributedString(title: String, subtitle: String) -> NSAttributedString {
        let titleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline), NSAttributedString.Key.foregroundColor: UIColor.purple]
        let subtitleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .subheadline)]

        let titleString = NSMutableAttributedString(string: "\(title)\n", attributes: titleAttributes)
        let subtitleString = NSAttributedString(string: subtitle, attributes: subtitleAttributes)

        titleString.append(subtitleString)

        return titleString
    }
}
