//
//  PhotoCell.swift
//  TableViewExample
//
//  Created by Alexander on 22.03.18.
//  Copyright © 2018 Alexander. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var timestampLabel: UILabel!
    
    // MARK: - Public
    
    func configure(with photoData: PhotoData) {
        imageView.image = photoData.image
        timestampLabel.text = photoData.date?.toString(dateFormat: "dd-MMM-yyyy HH:mm") ?? "No Date Available"
        
    }
    
    func configure(with image: UIImage, time: String) {
        imageView.image = image
        timestampLabel.text = time
    }
    
}
