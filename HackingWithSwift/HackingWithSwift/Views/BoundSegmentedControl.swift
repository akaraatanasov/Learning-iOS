//
//  BoundSegmentedControl.swift
//  HackingWithSwift
//
//  Created by Alexander Karaatanasov on 4.04.19.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import UIKit

class BoundSegmentedControl: UISegmentedControl {
    
    var changedClosure: (() -> ())?
    
    @objc func valueChanged() {
        changedClosure?()
    }
    
    func bind(to observable: ProjectsObservable<Int>) {
        addTarget(self, action: #selector(BoundSegmentedControl.valueChanged), for: .valueChanged)
        
        changedClosure = { [weak self] in
            observable.bindingChanged(to: self?.selectedSegmentIndex ?? 0)
        }
        
        observable.valueChanged = { [weak self] newValue in
            self?.selectedSegmentIndex = newValue ?? 0
        }
        
        self.selectedSegmentIndex = observable.value ?? 0
    }
}

