//
//  PhotoData.swift
//  TableViewExample
//
//  Created by Alexander on 28.03.18.
//  Copyright © 2018 Alexander. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class PhotoData {
    let image: UIImage
    let date: Date?
    let location: CLLocationCoordinate2D?
    
    init(image: UIImage, date: Date?, location: CLLocationCoordinate2D?) {
        self.image = image
        self.date = date
        self.location = location
    }
}
