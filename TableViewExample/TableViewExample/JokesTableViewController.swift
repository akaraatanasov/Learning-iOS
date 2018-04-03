//
//  JokesTableViewController.swift
//  TableViewExample
//
//  Created by Alexander on 30.03.18.
//  Copyright © 2018 Alexander. All rights reserved.
//

import UIKit

class JokesTableViewController: UIViewController {

    var jokesArray = [Joke]() {
        didSet {
            tableView.reloadData()
        }
    }

    @IBOutlet weak var tableView: UITableView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "jokeSegue" {
            if let viewController = segue.destination as? JokeViewController {
                
                if let jokeId = tableView.indexPathForSelectedRow?.row {
                    viewController.id = jokeId
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getJokes()
        
    }
    
    func getJokes() {
        let urlString = "https://api.icndb.com/jokes"
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
                let jokesData = try JSONDecoder().decode(ArrayResponse.self, from: data)

                DispatchQueue.main.async {
                    self.jokesArray = jokesData.value
                }
            } catch let jsonError {
                print(jsonError)
            }
        }
        
        task.resume()
    }
    
    
}

// MARK: - UITableViewDelegate
extension JokesTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "jokeSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            jokesArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.endUpdates()
        }
    }
    
}

// MARK: - UITableViewDataSource
extension JokesTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "All Chuck Noriss jokes"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jokesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "jokeCell")!
        cell.textLabel!.text = jokesArray[indexPath.row].joke
        return cell
    }
}
