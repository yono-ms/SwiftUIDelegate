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
    
    let script = """
        NativeApp = {}
        NativeApp.request = function (message) {
            window.webkit.messageHandlers.request.postMessage(message)
        }
    """

    func makeUIView(context: Context) -> WKWebView {
        print("WebView makeUIView")
        
        let path = Bundle.main.path(forResource: "sample", ofType: "html") ?? ""
        let url = URL(fileURLWithPath: path)
        let request = URLRequest(url: url)
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        webView.configuration.userContentController.add(context.coordinator, name: "request")
        webView.configuration.userContentController.addUserScript(WKUserScript(source: script, injectionTime: .atDocumentStart, forMainFrameOnly: true))
        context.coordinator.setWKWebView(webView: webView)
        webView.load(request)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        print("WebView updateUIView")
    }
    
    func makeCoordinator() -> WebViewCoordinator {
        print("WebView makeCoordinator")
        return WebViewCoordinator(owner: self)
    }
    
    typealias UIViewType = WKWebView
    typealias Coordinator = WebViewCoordinator
    
}

#Preview {
    WebView(isLoading: .constant(false))
}
