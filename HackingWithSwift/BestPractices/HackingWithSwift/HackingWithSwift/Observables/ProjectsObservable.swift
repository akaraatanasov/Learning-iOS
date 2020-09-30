//
//  ProjectsObservable.swift
//  HackingWithSwift
//
//  Created by Alexander Karaatanasov on 4.04.19.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import Foundation

class ProjectsObservable<Int> {
    
    // MARK: - Vars
    
    private var _value: Int?
    
    public var value: Int? {
        get {
            return _value
        }
        set {
            _value = newValue
            valueChanged?(_value)
        }
    }
    
    var valueChanged: ((Int?) -> ())?
    
    // MARK: - Inits
    
    init(_ value: Int) {
        self._value = value
    }
    
    // MARK: - Public
    
    func bindingChanged(to newValue: Int) {
        value = newValue
    }
    
}

