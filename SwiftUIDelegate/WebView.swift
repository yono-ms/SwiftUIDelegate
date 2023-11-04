//
//  WebView.swift
//  SwiftUIDelegate
//
//  Created by no name on 2023/11/05.
//  
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    @Binding var isLoading: Bool
    
    func makeUIView(context: Context) -> some UIView {
        let url = URL(string: "https://google.com")
        let request = URLRequest(url: url!)
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.load(request)
        return webView
    }
    
    func makeCoordinator() -> WebViewCoordinator {
        return WebViewCoordinator(owner: self)
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

class WebViewCoordinator: NSObject, WKNavigationDelegate {
    private let owner: WebView
    init(owner: WebView) {
        self.owner = owner
        super.init()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        owner.isLoading = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        owner.isLoading = false
    }
}

#Preview {
    WebView(isLoading: .constant(false))
}
