//
//  ViewController.swift
//  Project16-CapitalCities
//
//  Created by Alexander Karaatanasov on 14.05.19.
//  Copyright © 2019 Alexander Karaatanasov. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addMapAnnotations()
    }

    // MARK: - Private
    
    private func addMapAnnotations() {
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
        
        mapView.addAnnotations([london, oslo, paris, rome, washington])
    }
    
    private func presentAlert(withTitle title: String?, andMessage message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
    private func setCityAndCountryTitle(for annotation: MKPointAnnotation) {
        let annotationCoordinate = annotation.coordinate
        let location = CLLocation(latitude: annotationCoordinate.latitude, longitude: annotationCoordinate.longitude)
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            guard let placeMark = placemarks?.first else { return }
            
            var cityAndCountry = [String]()
            
            if let city = placeMark.locality ?? placeMark.subLocality {
                cityAndCountry.append(city)
            }
            
            if let country = placeMark.country {
                cityAndCountry.append(country)
            }
            
            annotation.title = cityAndCountry.isEmpty ? "Unknown Location" : cityAndCountry.joined(separator: ", ")
        })
    }
    
    // MARK: - IBActions
    
    @IBAction func mapTapped(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.mapView)
        let locationCoordinate = self.mapView.convert(location, toCoordinateFrom: self.mapView)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationCoordinate
        setCityAndCountryTitle(for: annotation)
        
        self.mapView.addAnnotation(annotation)
    }
}

// MARK: - Map View Delegate

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }

        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Capital") else {
            let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Capital")
            annotationView.canShowCallout = true
            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            return annotationView
        }
        
        annotationView.annotation = annotation
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        
        presentAlert(withTitle: capital.title, andMessage: capital.info)
    }
}
