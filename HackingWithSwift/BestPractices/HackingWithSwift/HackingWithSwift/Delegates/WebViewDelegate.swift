//
//  WebViewDelegate.swift
//  HackingWithSwift
//
//  Created by Alexander Karaatanasov on 25.03.19.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import WebKit

protocol URLOpening {
    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey: Any], completionHandler completion: ((Bool) -> Void)?)
}

class WebViewDelegate: NSObject, WKNavigationDelegate {
    
    // MARK: - Vars
    
    let allowedSites = ["apple.com", "hackingwithswift.com"]
    
    // MARK: - Public
    
    func openURL(_ url: URL, using: URLOpening = UIApplication.shared) {
        using.open(url, options: [:], completionHandler: nil)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let host = navigationAction.request.url?.host {
            if allowedSites.contains(where: host.contains) {
                decisionHandler(.allow)
                return
            }
        }
        
        if let url = navigationAction.request.url {
            openURL(url)
        }
        
        decisionHandler(.cancel)
    }
}

extension UIApplication: URLOpening { }
