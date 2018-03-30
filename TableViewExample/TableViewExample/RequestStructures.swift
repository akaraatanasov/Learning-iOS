//
//  RequestStructures.swift
//  TableViewExample
//
//  Created by Alexander on 30.03.18.
//  Copyright © 2018 Alexander. All rights reserved.
//

import UIKit

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
