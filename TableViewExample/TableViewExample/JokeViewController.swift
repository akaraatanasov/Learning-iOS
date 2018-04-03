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
    
    func getNextJoke() {
        guard let id = id else {
            return
        }
        
        self.id = id + 1
    }
    
    func getJoke() {
        guard let id = id else {
            return
        }
        
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
                let jokesData = try JSONDecoder().decode(Response.self, from: data)
                
                DispatchQueue.main.async {
                    self.jokeNumberLabel.text = "Joke Nº: \(id)"
                    
                    self.joke = jokesData.value.joke // MARK: - replace &quot; with " if any found
                    self.categories = jokesData.value.categories
                }
            } catch let jsonError {
                print(jsonError)
                self.getNextJoke()
            }
        }
        
        task.resume()
    }

}
