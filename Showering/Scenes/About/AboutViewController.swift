//
//  AboutViewController.swift
//  Showering
//
//  Created by Krzysztof Kinal on 10/10/2021.
//

import UIKit
import WebKit

class AboutViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        self.view = licensesWebView
    }
    
    private lazy var licensesWebView: WKWebView = {
        let webview = WKWebView()
        if let url = Bundle.main.url(forResource: "about", withExtension: "html") {
            webview.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        }
        
        return webview
    }()
}
