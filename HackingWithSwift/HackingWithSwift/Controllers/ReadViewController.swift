//
//  ReadViewController.swift
//  HackingWithSwift
//
//  Copyright © 2018 Hacking with Swift. All rights reserved.
//

import UIKit
import WebKit

class ReadViewController: UIViewController, LoggerHandling {

    // MARK: - Vars
    
    var delegate = WebViewDelegate()
    
    var webView = WKWebView()
    
    var project: Project!
    
    // MARK: - Lifecycle
    
    override func loadView() {
        webView.navigationDelegate = delegate

        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        assert(project != nil, "You must set a project before showing this view controller.")
        title = project.title
        log("Read project \(project.number).")

        guard let url = URL(string: "https://www.hackingwithswift.com/read/\(project.number)/overview") else {
            return
        }

        let request = URLRequest(url: url)
        webView.load(request)
    }
    
}
