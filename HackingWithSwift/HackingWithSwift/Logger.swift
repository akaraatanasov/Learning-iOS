//
//  Logger.swift
//  HackingWithSwift
//
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import UIKit

class Logger {
    private static let sharedLogger = Logger()

    static var shared: Logger {
        return sharedLogger
    }

    fileprivate init() { }

    func log(_ message: String) {
        print(message)
    }

    static func log(_ message: String) {
        shared.log(message)
    }
}
