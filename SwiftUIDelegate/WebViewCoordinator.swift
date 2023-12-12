//
//  WebViewCoordinator.swift
//  SwiftUIDelegate
//
//  Created by no name on 2023/12/07.
//  
//

import WebKit

class WebViewCoordinator: NSObject {
    private let owner: WebView
    init(owner: WebView) {
        self.owner = owner
        super.init()
    }
    
    private var wkWebView: WKWebView!
    
    func setWKWebView(webView: WKWebView) {
        self.wkWebView = webView
    }
}

// MARK: - WKNavigationDelegate
extension WebViewCoordinator: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("WKNavigationDelegate didStartProvisionalNavigation")
        owner.isLoading = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("WKNavigationDelegate didFinish")
        owner.isLoading = false
    }
}

// MARK: - WKUIDelegate
extension WebViewCoordinator: WKUIDelegate {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo) async {
        print("WKUIDelegate runJavaScriptAlertPanelWithMessage \(message)")
    }
}

// MARK: - WKScriptMessageHandler
extension WebViewCoordinator: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("WKScriptMessageHandler didReceive \(message.name) \(message.body)")
        switch message.name {
        case "request":
            print("send response.")
            DispatchQueue.main.async {
                let script = """
                    responseNative("hello world!")
                """
                self.wkWebView.evaluateJavaScript(script)
            }
        default:
            print("unknown")
        }
    }
}
