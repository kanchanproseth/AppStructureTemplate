//
//  WebViewController.swift
//  MediaParkAssignment
//
//  Created by Kan Chanproseth on 09/03/2022.
//

import UIKit
import WebKit
import RxSwift
import RxRelay
import NVActivityIndicatorView

class WebViewController: UIViewController {
    
    private var webViewKit: WKWebView!
    private var activityIndicatorView: NVActivityIndicatorView!
    private var isLoading = PublishSubject<Bool>()
    private let disposeBag = DisposeBag()
    internal var urlString: String?
    
    
    public static func builder(urlString: String) -> WebViewController {
        let scene = WebViewController()
        scene.urlString = urlString
        return scene
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpBinding()
    }
    
}

private extension WebViewController {
    func setUpUI() {
        setupNavigationLogo()
        setupWebView()
    }
    
    func setUpBinding() {
        isLoading
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: {[weak self] isLoading in
                guard let self = self else { return }
                isLoading ? self.activityIndicatorView.startAnimating() : self.activityIndicatorView.stopAnimating()
            }).disposed(by: disposeBag)
        
        setupCloseButton()
            .subscribe(onNext: {
                self.navigationController?.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBag)
    }
    
    func setupWebView() {
        activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: view.bounds.maxX/2, y: view.bounds.maxY/2, width: 50, height: 50),
                                                        type: .pacman,
                                                        color: UIColor.orange.withAlphaComponent(0.7))
        view.addSubview(activityIndicatorView)
        
        
        webViewKit = WKWebView()
        view.addSubviewAndFill(webViewKit)
        webViewKit.uiDelegate = self
        webViewKit.navigationDelegate = self
        guard let url = URL(string: self.urlString ?? "") else {
            return
        }
        webViewKit.load(URLRequest(url: url))
        view.bringSubviewToFront(activityIndicatorView)
        
    }
    
    func setupNavigationLogo() {
        self.navigationController?.navigationBar.transparentNavigationBar()
        
        let logo = UIImage(named: "Logo")
        let imageView = UIImageView(image:logo)
        navigationItem.titleView = imageView
    }
    
    func setupCloseButton() -> Observable<Void> {
        let icon = UIImage(named: "cross")!.resizeImage(15, opaque: false)
        let barButtonItem = UIBarButtonItem(image: icon, style: UIBarButtonItem.Style.plain, target: self, action: nil)
        barButtonItem.tintColor = UIColor.orange.withAlphaComponent(0.5)
        navigationItem.rightBarButtonItem = barButtonItem
        return barButtonItem.rx.tap.asObservable()
    }
}

// MARK: -
// MARK: WKUIDelegate
extension WebViewController: WKUIDelegate {}

// MARK: -
// MARK: WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        isLoading.onNext(true)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        isLoading.onNext(false)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        guard let url = URL(string: self.urlString ?? "") else {
            return
        }
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated  {
            if let url = navigationAction.request.url,
               let host = url.host, !host.hasPrefix("www.google.com") {
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
        } else {
            decisionHandler(.allow)
        }
    }
    
}

