//
//  FileManager+Extensions.swift
//  HackingWithSwift
//
//  Created by Alexander Karaatanasov on 3.04.19.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import Foundation

protocol DirectoryManagerDelegate {
    func fileExists(atPath path: String) -> Bool
    func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask) -> [URL]
}

extension FileManager: DirectoryManagerDelegate { }
