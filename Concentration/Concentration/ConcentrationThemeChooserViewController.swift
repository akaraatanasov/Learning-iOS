//
//  ConcentrationThemeChooserViewController.swift
//  Concentration
//
//  Created by Alexander on 29.01.18.
//  Copyright © 2018 Alexander. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController, UISplitViewControllerDelegate {

    let themes = [
        "Sports" : "⚽️🏀🏈⚾️🎾🏐🏉🎱🏓⛷🎳⛳️",
        "Animals" : "🐶🐔🦊🐼🦀🐪🐓🐋🐙🦄🐵",
        "Faces" : "😀😂😎🤩😩😢😴🤫🤥😘😉"
    ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        splitViewController?.delegate = self
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if let cvc = secondaryViewController as? ConcentrationViewController {
            if cvc.theme == nil {
                return true
            }
        }
        return false
    }
    
    @IBAction func changeTheme(_ sender: Any) {
        if let cvc = splitViewDetailConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
            }
        } else if let cvc = lastSeguedToConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
            }
        } else {
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }

    private var splitViewDetailConcentrationViewController: ConcentrationViewController? {
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    
    // MARK: - Navigation
    
    private var lastSeguedToConcentrationViewController: ConcentrationViewController?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                if let cvc = segue.destination as? ConcentrationViewController {
                    cvc.theme = theme
                    lastSeguedToConcentrationViewController = cvc
                } 
            }
            
        }
    }


}
