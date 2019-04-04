//
//  UserObservable.swift
//  HackingWithSwift
//
//  Created by Alexander Karaatanasov on 4.04.19.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import Foundation

class NameObservable<String> {
    
    // MARK: - Vars
    
    private var _value: String?
    
    public var value: String? {
        get {
            return _value
        }
        set {
            _value = newValue
            valueChanged?(_value)
        }
    }
    
    var valueChanged: ((String?) -> ())?
    
    // MARK: - Inits
    
    init(_ value: String) {
        self._value = value
    }
    
    // MARK: - Public
    
    func bindingChanged(to newValue: String) {
        value = newValue
    }
    
}
