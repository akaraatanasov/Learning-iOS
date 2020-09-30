//
//  RequestStructures.swift
//  TableViewExample
//
//  Created by Alexander on 30.03.18.
//  Copyright © 2018 Alexander. All rights reserved.
//

import UIKit
import CoreData

struct ArrayResponse: Codable {
    let type: String
    let value: [Joke]
}

struct Response: Codable {
    let type: String
    let value: Joke
}

struct Joke: Codable {
    let id: Int
    let joke: String
    let categories: [String]
}

enum ResponseError: Error {
    case NoSuchQuoteException(String)
}

//class Jokes: NSManagedObject {
//    @NSManaged var id: Int
//    @NSManaged var joke: String
//    @NSManaged var categories: [String]
//}
