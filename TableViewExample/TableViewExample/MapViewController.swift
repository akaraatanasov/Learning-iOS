//
//  MapViewController.swift
//  TableViewExample
//
//  Created by Alexander on 27.03.18.
//  Copyright © 2018 Alexander. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var coordinatesFromPhoto: CLLocationCoordinate2D?
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewWillAppear(_ animated: Bool) {
        guard let coordinates = coordinatesFromPhoto else {
            let alert = UIAlertController(title: "Error", message: "Your photo doesn't have location", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: { (_) in
                self.navigationController?.popViewController(animated: true)
            })
            
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
            return
        }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        mapView.addAnnotation(annotation)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        mapView.region = MKCoordinateRegion(center: coordinatesFromPhoto!, span: span)
    
    }
}
