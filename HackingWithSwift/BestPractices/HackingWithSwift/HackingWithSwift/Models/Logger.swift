//
//  Logger.swift
//  HackingWithSwift
//
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import UIKit

protocol LoggerHandling {
    func log(_ message: String)
}

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
}

extension LoggerHandling {
    func log(_ message: String) {
        Logger.shared.log(message)
    }
}
