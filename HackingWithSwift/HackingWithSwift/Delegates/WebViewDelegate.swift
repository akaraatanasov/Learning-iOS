//
//  WebViewDelegate.swift
//  HackingWithSwift
//
//  Created by Alexander Karaatanasov on 25.03.19.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import WebKit

class WebViewDelegate: NSObject, WKNavigationDelegate {
    
    let allowedSites = ["apple.com", "hackingwithswift.com"]
    
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
