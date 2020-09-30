//
//  ViewController.swift
//  Project18-Debugging
//
//  Created by Alexander Karaatanasov on 14.05.19.
//  Copyright © 2019 Alexander Karaatanasov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        printTest()
//        assertTest()
        breakpointTest()
    }
    
    // MARK: - Private
    
    private func printTest() {
        print(1, 2, 3, 4, 5, separator: "-")
        print("Some message", terminator: "")
    }
    
    private func assertTest() {
        assert(1 == 1, "Maths failure!")
        assert(1 == 2, "Maths failure!")
    }
    
    private func breakpointTest() {
        for i in 1 ... 100 {
            print("Got number \(i)")
        }
    }


}

