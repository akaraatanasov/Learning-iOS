//
//  CassiniViewController.swift
//  Cassini
//
//  Created by Alexander on 7.03.18.
//  Copyright © 2018 Alexander. All rights reserved.
//

import UIKit

class CassiniViewController: UIViewController {

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if let url = DemoURLs.NASA[identifier] {
                if let imageViewController = segue.destination.contents as? ImageViewController {
                    imageViewController.imageURL = url
                    imageViewController.title = (sender as? UIButton)?.currentTitle
                }
            }
        }
    }

}

extension UIViewController {
    var contents: UIViewController {
        if let navigationController = self as? UINavigationController {
            return navigationController.visibleViewController ?? self
        } else {
            return self
        }
    }
}
