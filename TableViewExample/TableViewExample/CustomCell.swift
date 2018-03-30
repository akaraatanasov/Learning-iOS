//
//  CustomCell.swift
//  TableViewExample
//
//  Created by Alexander on 19.03.18.
//  Copyright © 2018 Alexander. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var titleImage: UIImageView!

    // MARK: - Public
    
    func configureCell(with item: String, and image: UIImage) {
        titleLabel.text = item
        titleImage.image = image
    }
    
}
