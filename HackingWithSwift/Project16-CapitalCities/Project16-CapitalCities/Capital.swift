//
//  Capital.swift
//  Project16-CapitalCities
//
//  Created by Alexander Karaatanasov on 14.05.19.
//  Copyright © 2019 Alexander Karaatanasov. All rights reserved.
//

import MapKit
import UIKit

class Capital: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
