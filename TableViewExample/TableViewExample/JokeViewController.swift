//
//  JokeViewController.swift
//  TableViewExample
//
//  Created by Alexander on 30.03.18.
//  Copyright © 2018 Alexander. All rights reserved.
//

import UIKit

class JokeViewController: UIViewController {

    var id: Int? {
        didSet {
            getJoke()
        }
    }
    
    var joke: String? {
        didSet {
            jokeTextView.text = joke
        }
    }
    
    var categories = [String]() {
        didSet {
            let joinedCategories = categories.joined(separator: ", ")
            jokeCategoriesLabel.text = "Categories: \(joinedCategories)"
        }
    }
    
    @IBOutlet weak var jokeNumberLabel: UILabel!
    
    @IBOutlet weak var jokeTextView: UITextView!
    
    @IBOutlet weak var jokeCategoriesLabel: UILabel!
    
    @IBAction func nextJokeButton(_ sender: Any) {
        getNextJoke()
    }
    
    // fetches the joke from the web and saves it to the documents directory
    func fetchJoke() {
        print("---fetching joke from the web---")
        
        guard let id = id else {
            print("---no such id exist---")
            return
        }
        
        let fileUrl = getDocumentsURL().appendingPathComponent("\(id).json")
        
        let urlString = "https://api.icndb.com/jokes/\(id)"
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error: \(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
            }
            
            do {
                // Doing this to check if the JSON can decode the json and if yes - it will save itself to the documents folder - else it will throw
                try JSONDecoder().decode(Response.self, from: data)
                // Write this data to the fileUrl
                try data.write(to: fileUrl)
                self.getJoke()
            } catch let error {
                print(error)
                
                self.getNextJoke()
            }
        }
        
        task.resume()
    }
    
    // gets the joke from the documents directory
    func getJoke() {
        print("---getting joke from documents folder---")
        
        guard let id = id else {
            print("---no such id exist---")
            return
        }
        
        let fileUrl = getDocumentsURL().appendingPathComponent("\(id).json")
        
        do {
            let data = try Data(contentsOf: fileUrl) // Read this data from the fileUrl
            let jokesData = try JSONDecoder().decode(Response.self, from: data)
            
            DispatchQueue.main.async {
                self.jokeNumberLabel.text = "Joke Nº: \(id)"
                self.joke = jokesData.value.joke // MARK: - replace &quot; with " if any found
                self.categories = jokesData.value.categories
            }
            
        } catch let error {
            print(error)
            
            fetchJoke()
        }
    }
    
    func getNextJoke() {
        guard let id = id else {
            return
        }
        
        self.id = id + 1
    }

    func getDocumentsURL() -> URL {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return url
        } else {
            fatalError("Could not retrieve documents directory")
        }
    }
}
