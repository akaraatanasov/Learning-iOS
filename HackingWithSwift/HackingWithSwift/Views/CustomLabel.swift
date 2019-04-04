//
//  CustomLabel.swift
//  HackingWithSwift
//
//  Created by Alexander Karaatanasov on 28.02.19.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {
    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    convenience init(with projectText: String, and textStyle: UIFont.TextStyle) {
        self.init()
        font = UIFont.preferredFont(forTextStyle: textStyle)
        text = projectText
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        numberOfLines = 0
    }
    
}
