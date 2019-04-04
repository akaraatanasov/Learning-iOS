//
//  ReadViewController.swift
//  HackingWithSwift
//
//  Copyright © 2018 Hacking with Swift. All rights reserved.
//

import UIKit
import WebKit

class ReadViewController: UIViewController, WKNavigationDelegate {
    var webView = WKWebView()
    var project: Project!

    let allowedSites = ["apple.com", "hackingwithswift.com"]

    override func loadView() {
        webView.navigationDelegate = self

        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        assert(project != nil, "You must set a project before showing this view controller.")
        title = project.title
        Logger.log("Read project \(project.number).")

        guard let url = URL(string: "https://www.hackingwithswift.com/read/\(project.number)/overview") else {
            return
        }

        let request = URLRequest(url: url)
        webView.load(request)
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let host = navigationAction.request.url?.host {
            if allowedSites.contains(where: host.contains) {
                decisionHandler(.allow)
                return
            }
        }

        if let url = navigationAction.request.url {
            UIApplication.shared.open(url, options: [:])
        }
        
        decisionHandler(.cancel)
    }
}
