//
//  BoundTextField.swift
//  HackingWithSwift
//
//  Created by Alexander Karaatanasov on 4.04.19.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import UIKit

class BoundTextField: UITextField {
    
    var changedClosure: (() -> ())?
    
    @objc func valueChanged() {
        changedClosure?()
    }
    
    func bind(to observable: NameObservable<String>) {
        addTarget(self, action: #selector(BoundTextField.valueChanged), for: .editingChanged)
        
        changedClosure = { [weak self] in
            observable.bindingChanged(to: self?.text ?? "")
        }
        
        observable.valueChanged = { [weak self] newValue in
            self?.text = newValue
        }
        
        self.text = observable.value
    }
}
