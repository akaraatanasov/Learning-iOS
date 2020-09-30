//
//  PhotoCollectionViewController.swift
//  TableViewExample
//
//  Created by Alexander on 22.03.18.
//  Copyright © 2018 Alexander. All rights reserved.
//

import UIKit
import Photos
import CoreLocation

class PhotoCollectionViewController: UIViewController, UINavigationControllerDelegate {
    let imagePicker = UIImagePickerController()
    
    let locationManager: CLLocationManager = CLLocationManager()
    
    var photos = [PhotoData]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var selectedItemCoordinates: CLLocationCoordinate2D?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func addPhoto(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Select Photo", message: "What would you like to use?", preferredStyle: .actionSheet)
        let cameraButton = UIAlertAction(title: "Take a picture 📷", style: .default, handler: { (action) -> Void in
            print("Take a picture 📷 button tapped")
            self.takePictureFromCamera()
        })
        
        let libraryButton = UIAlertAction(title: "Choose from library", style: .default, handler: { (action) -> Void in
            print("Choose from library button tapped")
            self.takePictureFromLibrary()
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        
        alertController.addAction(cameraButton)
        alertController.addAction(libraryButton)
        alertController.addAction(cancelButton)
        
        navigationController!.present(alertController, animated: true, completion: nil)
    }
    
    func takePictureFromCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func takePictureFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapSegue" {
            if let viewController = segue.destination as? MapViewController {
                viewController.coordinatesFromPhoto = selectedItemCoordinates // send coordinates to MapViewController
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension PhotoCollectionViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // photo retrieval
        guard let photoTaken = (info[UIImagePickerControllerEditedImage] as? UIImage) ?? // for library
                          (info[UIImagePickerControllerOriginalImage] as? UIImage) else { // for camera (no editing)
                return
        }
        
        // metadata retrieval
        var timeTaken: Date?
        var locationTaken: CLLocationCoordinate2D?
        
        if let phAsset = info[UIImagePickerControllerPHAsset] as? PHAsset { // case for photo library
            timeTaken = phAsset.creationDate
            locationTaken = phAsset.location?.coordinate
        } else { // case for camera
            // adding current date and time
            timeTaken = Date()
            // adding current location
            locationManager.requestLocation()
            locationTaken = locationManager.location?.coordinate
        }
        
        let photoData = PhotoData(image: photoTaken, date: timeTaken, location: locationTaken)
        photos.append(photoData)

        dismiss(animated: true, completion: nil)
    }
}

// MARK: - CLLocationManagerDelegate
extension PhotoCollectionViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last! as CLLocation
        let coordinates = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        print("Updated location. Got one with latitude: \(coordinates.latitude) and longitude: \(coordinates.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Retrieving location failed. Error: \(error)")
    }
}

// MARK: - UICollectionViewDelegate
extension PhotoCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItemCoordinates = photos[indexPath.item].location
        // saveImageToLibrary(fromItemAt: indexPath)
        performSegue(withIdentifier: "mapSegue", sender: indexPath.item)
    }
    
    func saveImageToLibrary(fromItemAt indexPath: IndexPath) {
        let imageData = UIImageJPEGRepresentation(photos[indexPath.item].image, 0.6)
        let compressedJPGImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
        
        let alertController = UIAlertController(title: "Wow", message: "Your image has been saved to Photo Library!", preferredStyle: .alert)
        
        let cancelButton = UIAlertAction(title: "OK", style: .cancel, handler: { (action) -> Void in
            print("OK button tapped")
        })
        
        alertController.addAction(cancelButton)
        navigationController!.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource
extension PhotoCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
        let photo = photos[indexPath.item]
        
        cell.configure(with: photo)
        
        return cell
    }
}

extension Date {
    func toString(dateFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
