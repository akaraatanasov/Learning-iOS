//
//  Logger.swift
//  HackingWithSwift
//
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import UIKit

class Logger {
    
    // MARK: - Vars
    
    private static let sharedLogger = Logger()

    static var shared: Logger {
        return sharedLogger
    }
    
    // MARK: - Inits

    fileprivate init() { }
    
    // MARK: - Public

    func log(_ message: String) {
        print(message)
    }

    static func log(_ message: String) {
        shared.log(message)
    }
}
