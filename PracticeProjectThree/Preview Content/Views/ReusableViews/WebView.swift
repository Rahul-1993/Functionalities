//
//  WebView.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 2/17/25.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    

}

#Preview {
    WebView(url: URL(string: "https://www.hackingwithswift.com/articles/239/wwdc21-wrap-up-and-recommended-talks")!)
}
