//
//  DetailView.swift
//  HackingWithSwift
//
//  Created by Alexander Karaatanasov on 28.02.19.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import UIKit

class DetailView: UIView {

    // MARK: - Vars
    
    var action: (()->())?
    
    // MARK: - Inits
    
    init(with project: Project, action: @escaping (() -> ())) {
        super.init(frame: .zero)
        self.action = action
        
        backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollView)
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            
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
        
        let titleLabel = CustomLabel(with: project.title, and: .largeTitle)
        let detailLabel = CustomLabel(with: project.subtitle, and: .body)
        let learnTitleLabel = CustomLabel(with: "You'll learn…", and: .title1)
        let learnDetailLabel = CustomLabel(with: project.topics, and: .body)
        
        let showButton = UIButton(type: .system)
        showButton.translatesAutoresizingMaskIntoConstraints = false
        showButton.setTitle("Start Reading", for: .normal)
        showButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        showButton.addTarget(self, action: #selector(readButtonPressed), for: .touchUpInside)
        
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    @objc private func readButtonPressed() {
        action?()
    }
}
