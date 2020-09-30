//
//  ViewController.swift
//  SimpleCollectionView
//
//  Created by Alexander on 16.03.18.
//  Copyright © 2018 Alexander. All rights reserved.
//

import UIKit

class ViewController: UIViewController,
UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Vars
    
    var suitsArray = [Dictionary<String, AnyObject>]()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Enums
    
    enum ParsingError: Error {
        case MissingJson
        case JsonParsingError
    }
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try setupData()
        } catch ParsingError.MissingJson {
            print("Error loading JSON")
        } catch ParsingError.JsonParsingError {
            print("Error parsing JSON")
        } catch {
            print("Something went wrong")
        }
        
        // Configure collection view
        configureCollectionView()
        
    }
    
    // MARK: Data setup
    
    func setupData() throws {
        guard let filePath = Bundle.main.path(forResource: "cards", ofType: "json"),
            let jsonData = NSData(contentsOfFile: filePath) else {
                throw ParsingError.MissingJson
        }

        do {
            let parsedObject = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            suitsArray = parsedObject["suits"] as! Array
        } catch {
            throw ParsingError.JsonParsingError
        }
        
    }
    
    // MARK: Register cell nib
    
    func configureCollectionView() {
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardCell")
    }
    
}

// MARK: UICollectionViewDataSource stubs

extension ViewController: UICollectionViewDataSource {
    
    // how many items in current section?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let cardsDictionary = suitsArray[section]
        let cardsArray = cardsDictionary["cards"] as! NSArray
        
        return cardsArray.count
    }
    
    // how many sections? (optional) - if not implemented it will return 1
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return suitsArray.count
    }
    
    // configure cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath)
        
        let suitDictionary = suitsArray[indexPath.section]
        let cardsArray = suitDictionary["cards"] as! [Dictionary<String, AnyObject>]
        let cardDictionary = cardsArray[indexPath.row]
        
        let cardImageName = cardDictionary["cardImage"] as! String
        if let cardImage = UIImage(named: cardImageName) {
            
            if let imageView = cell.contentView.viewWithTag(1000) as? UIImageView {
                imageView.image = cardImage
            }
        }
        
        return cell
    }

}

