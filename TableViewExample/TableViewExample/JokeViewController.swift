//
//  JokeViewController.swift
//  TableViewExample
//
//  Created by Alexander on 30.03.18.
//  Copyright © 2018 Alexander. All rights reserved.
//

import UIKit
import CoreData

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
    
    var jokeData: Jokes?
    
    @IBOutlet weak var jokeNumberLabel: UILabel!
    
    @IBOutlet weak var jokeTextView: UITextView!
    
    @IBOutlet weak var jokeCategoriesLabel: UILabel!
    
    @IBAction func nextJokeButton(_ sender: Any) {
        getNextJoke()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Joke Nº: \(id ?? -1)"
    }
    
    func fetchJoke() {
        print("---fetching joke from the Web---")
        
        guard let id = id else {
            print("---no such id exist---")
            return
        }
        
        let urlString = "https://api.icndb.com/jokes/\(id)"
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error: \(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
            }
            
            do {
                let decodedData = try JSONDecoder().decode(Response.self, from: data)
                
                // Write this data to CoreData
                let responseType = decodedData.type
                if responseType == "success" {
                    let id = decodedData.value.id
                    let joke = decodedData.value.joke
                    let categories = decodedData.value.categories
                    
                    print("---saving  joke  to  CoreData---")
                    DispatchQueue.main.async { [weak self] in
                        self?.saveJoke(jokeId: id, jokeString: joke, jokeCategories: categories)
                        self?.getJoke()
                    }
                } else {
                    throw ResponseError.NoSuchQuoteException("There is no joke with this id.")
                }
                
            } catch let error {
                print(error)
                
                self?.getNextJoke()
            }
        }

        task.resume()
    }
    
    func getJoke() {
        print("---getting joke from CoreData---")
        
        guard let id = id else {
            print("---no such id exist---")
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            if self!.jokeExists(withId: id) {
                self?.title = "Joke Nº: \(id)"
                self?.jokeNumberLabel.text = "Joke Nº: \(id)"
                self?.joke = self!.jokeData?.joke
                self?.categories = self!.jokeData?.categories as! [String]
            } else {
                print("\n  There is no joke with id: \(id)")
                self?.fetchJoke()
            }
        }
    }
    
    func saveJoke(jokeId id: Int, jokeString joke: String, jokeCategories categories: [String]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let jokeEntity = NSEntityDescription.entity(forEntityName: "Jokes", in: managedContext)!
        let jokeObject = NSManagedObject(entity: jokeEntity, insertInto: managedContext)
        
        jokeObject.setValue(id, forKeyPath: "id")
        jokeObject.setValue(joke, forKeyPath: "joke")
        jokeObject.setValue(categories, forKeyPath: "categories")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func jokeExists(withId id: Int) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Jokes> = Jokes.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %d", id)
        fetchRequest.fetchLimit = 1
        
        do {
            let count = try managedContext.count(for: fetchRequest) // getting the count of elements with this id
            jokeData = try managedContext.fetch(fetchRequest).first // getting the first element with this id
            
            return count > 0
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            
            return false
        }
    }
    
    func getNextJoke() {
        guard let id = id else {
            return
        }
        
        self.id = id + 1
    }
    
}
