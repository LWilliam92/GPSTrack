//
//  WebviewViewController.swift
//  QPlus
//
//  Created by Kar Wai Ng on 17/09/2022.
//

import UIKit
import WebKit
import iProgressHUD

class WebviewViewController: UIViewController {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var webview: WKWebView!
    
    @IBOutlet weak var closePopUpView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        iProgressHUD.sharedInstance().attachProgress(toView: self.view)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        CoreSingletonData.shared.webViewType = .none
        CoreSingletonData.shared.toOpenUrl = ""
        CoreSingletonData.shared.gameHost = ""
    }
    
    func setupView() {
        closePopUpView.isHidden = true
        webview.navigationDelegate = self
        let url = URL(string: CoreSingletonData.shared.toOpenUrl ?? "")
        webview.load(URLRequest(url: url!))
        self.titleLbl.text = CoreSingletonData.shared.gameHost
    }
    
    @IBAction func closeWebViewClicked(_ sender: Any) {
        closePopUpView.isHidden = false
    }
    
    @IBAction func backPageClicked(_ sender: Any) {
        if self.webview.canGoBack == true {
            self.webview.goBack()
            self.webview.reload()
        }
    }
    
    @IBAction func yesBtnClicked(_ sender: Any) {
        if CoreSingletonData.shared.webViewType == .game {
            view.showProgress()
            AlamoFireNetworking().getLogoutGameBalance(params: [:]) { response, error in
                if error == nil {
                    self.view.dismissProgress()
                    if response?.status == 1 {
                        self.closePopUpView.isHidden = true
                        self.dismiss(animated: true)
                    } else {
                        showAlertView("Error".localized(), response?.message ?? "", controller: self, completion: nil)
                    }
                } else {
                    self.view.dismissProgress()
                    showAlertView("Service Temporary Unavailable", "", controller: self, completion: { [weak self] in
                        guard self != nil else { return }
                        performLogout()
                    })
                }
            }
        } else {
            closePopUpView.isHidden = true
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func noBtnClicked(_ sender: Any) {
        closePopUpView.isHidden = true
    }
}

extension WebviewViewController: WKNavigationDelegate{
    //Equivalent of shouldStartLoadWithRequest:
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        var action: WKNavigationActionPolicy?

        defer {
            decisionHandler(action ?? .allow)
        }

        guard let url = navigationAction.request.url else { return }
        print("decidePolicyFor - url: \(url)")

        //Uncomment below code if you want to open URL in safari
        /*
        if navigationAction.navigationType == .linkActivated, url.absoluteString.hasPrefix("https://developer.apple.com/") {
            action = .cancel  // Stop in WebView
            UIApplication.shared.open(url)
        }
        */
    }

    //Equivalent of webViewDidStartLoad:
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("didStartProvisionalNavigation - webView.url: \(String(describing: webView.url?.description))")
        
        if webView.url?.description.contains("close.html") == true {
            self.dismiss(animated: true)
        }
        if webView.url?.description.contains("/Home/Failed") == true {
            self.dismiss(animated: true)
        }
    }

    //Equivalent of didFailLoadWithError:
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        let nserror = error as NSError
        if nserror.code != NSURLErrorCancelled {
            self.dismiss(animated: true)
        }
    }

    //Equivalent of webViewDidFinishLoad:
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("didFinish - webView.url: \(String(describing: webView.url?.description))")
    }
}
