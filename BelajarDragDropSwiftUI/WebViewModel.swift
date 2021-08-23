//
//  WebViewModel.swift
//  BelajarDragDropSwiftUI
//
//  Created by zein rezky chandra on 16/08/21.
//

import Foundation
import WebKit

class WebViewModel: ObservableObject {
    
    let webView: WKWebView
    
    init() {
        webView = WKWebView(frame: .zero)
    }
    
    func loadURLFrom(url: String) {
        guard let url = URL(string: url) else {
            return
        }
        
        webView.load(URLRequest(url: url))
    }
    
}
