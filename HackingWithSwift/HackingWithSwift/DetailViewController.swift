//
//  DetailViewController.swift
//  HackingWithSwift
//
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var project: Project!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let project = project else {
            assertionFailure("You must set a project before showing this view controller.")
            return
        }

        navigationItem.largeTitleDisplayMode = .never
        title = "Project \(project.number)"
        Logger.log("Showed project \(project.number).")

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 20),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])

        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit

        if project.number % 3 == 1 {
            let renderer = AppProjectRenderer(for: project)
            imageView.image = renderer.drawTitleImage()
        } else if project.number % 3 == 2 {
            let renderer = GameProjectRenderer(for: project)
            imageView.image = renderer.drawTitleImage()
        } else {
            let renderer = TechniqueProjectRenderer(for: project)
            imageView.image = renderer.drawTitleImage()
        }

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        titleLabel.numberOfLines = 0
        titleLabel.text = project.title

        let detailLabel = UILabel()
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.numberOfLines = 0
        detailLabel.font = UIFont.preferredFont(forTextStyle: .body)
        detailLabel.text = project.subtitle

        let learnTitleLabel = UILabel()
        learnTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        learnTitleLabel.numberOfLines = 0
        learnTitleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        learnTitleLabel.text = "You'll learn…"

        let learnDetailLabel = UILabel()
        learnDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        learnDetailLabel.numberOfLines = 0
        learnDetailLabel.font = UIFont.preferredFont(forTextStyle: .body)
        learnDetailLabel.text = project.topics

        let showButton = UIButton(type: .system)
        showButton.translatesAutoresizingMaskIntoConstraints = false
        showButton.setTitle("Start Reading", for: .normal)
        showButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        showButton.addTarget(self, action: #selector(readProject), for: .touchUpInside)

        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(detailLabel)
        stackView.addArrangedSubview(learnTitleLabel)
        stackView.addArrangedSubview(learnDetailLabel)
        stackView.addArrangedSubview(showButton)

        stackView.spacing = 10
        stackView.setCustomSpacing(40, after: detailLabel)
        stackView.setCustomSpacing(40, after: learnDetailLabel)
    }

    @objc func readProject() {
        guard let readVC = storyboard?.instantiateViewController(withIdentifier: "ReadViewController") as? ReadViewController else {
            return
        }

        readVC.project = project
        navigationController?.pushViewController(readVC, animated: true)
    }
}
