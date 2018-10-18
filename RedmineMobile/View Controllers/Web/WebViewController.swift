//
//  WebViewController.swift
//  BMNSafety
//
//  Created by Callum Trounce on 13/03/2018.
//  Copyright © 2018 DTT. All rights reserved.
//

import UIKit
import WebKit
import RxWebKit
import RxSwift
import RxCocoa

/// DTT's spiciest WebViewController yet!
class WebViewController: UIViewController {

    private let authService = AuthenticationService()
   
    
    @IBOutlet weak var webContainerView: UIView! {
        didSet {
            webView = WKWebView()
            webView.uiDelegate = self
            webView.navigationDelegate = self
            webView.translatesAutoresizingMaskIntoConstraints = false
            webContainerView.addSubview(webView)
            webContainerView.sendSubview(toBack: webView)
            webView.leftAnchor.constraint(equalTo: webContainerView.leftAnchor).isActive = true
            webView.topAnchor.constraint(equalTo: webContainerView.topAnchor).isActive = true
            webView.rightAnchor.constraint(equalTo: webContainerView.rightAnchor).isActive = true
            webView.bottomAnchor.constraint(equalTo: webContainerView.bottomAnchor).isActive = true
        }
    }
    
    private var webView: WKWebView! {
        didSet {
            observeWebView()
        }
    }
    
    @IBOutlet weak var progressView: UIProgressView! {
        didSet {
            progressView.progressTintColor = .redmineBlue
        }
    }
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    private var urlRequest: URLRequest!
    
    init(requestURL: URL) {
        super.init(nibName: "WebViewController", bundle: nil)
        urlRequest = URLRequest.init(url: requestURL)
        urlRequest.setValue(authService.credentials(), forHTTPHeaderField: "Authorization")
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(urlRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func observeWebView() {
        
        // observe the loading progress and update the progress bar.
        webView.rx.estimatedProgress.map { Float($0) }
            .bind(to: progressView.rx.progress)
            .disposed(by: disposeBag)
        
        // hide it when finished navigation.
        webView.rx.loading.map { !$0 }.bind(to: progressView.rx.isHidden)
            .disposed(by: disposeBag)
    }
}

extension WebViewController: WKUIDelegate {
    
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.view.tintColor = .redmineBlue
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            completionHandler()
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.view.tintColor = .redmineBlue
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            completionHandler(true)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            completionHandler(false)
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
}

extension WebViewController: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let disposition = URLSession.AuthChallengeDisposition.useCredential
        let credential = URLCredential.init(user: "ctrounce", password: "Interficio21.", persistence: .forSession)
        print(challenge.proposedCredential.debugDescription) 
        completionHandler(disposition, credential)
        
        print("challenge recieved!")
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("asked to redirect")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    
 
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        var request = navigationAction.request
        if let authHeader = request.value(forHTTPHeaderField: "Authorization") {
            print("currently authorized at ", authHeader)
            decisionHandler(.allow)
        } else {
            print("request not authorized")
            decisionHandler(.cancel)
            request.setValue(authService.credentials(), forHTTPHeaderField: "Authorization")
            webView.load(request)
        }
    }
}
