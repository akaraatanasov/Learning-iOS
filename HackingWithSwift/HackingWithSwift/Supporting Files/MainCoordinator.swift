//
//  MainCoordinator.swift
//  HackingWithSwift
//
//  Created by Alexander Karaatanasov on 4.04.19.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import UIKit

class MainCoordinator {
    
    // MARK: - Vars
    
    var navigationController: UINavigationController
    
    // MARK: - Inits
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Public
    
    func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        vc.coordinator = self
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    // MARK: - Private
}
