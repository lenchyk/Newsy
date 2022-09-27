//
//  WebViewController.swift
//  Newsy
//
//  Created by Lena Soroka on 27.09.2022.
//

import Foundation
import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    private var webView: WKWebView?
    var webViewModel: WebViewModel?
    
    override func loadView() {
        super.loadView()
        setupWebView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        addBackButton()
    }
    
    private func setupWebView() {
        webView = WKWebView()
        webView?.navigationDelegate = self
        view = webView
    }
    
    private func initialSetup() {
        guard let url = webViewModel?.mainURL else { return }
        webView?.load(URLRequest(url: url))
        webView?.allowsBackForwardNavigationGestures = true
    }
    
    private func addBackButton() {
        let backButton = UIButton(type: .close)
        backButton.frame = CGRect(x: 10, y: 46, width: 35, height: 35)
        backButton.addTarget(self, action: #selector(goBack(_:)), for: .touchUpInside)
        view.addSubview(backButton)
    }
    
    @objc private func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
