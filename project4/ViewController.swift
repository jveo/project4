//
//  ViewController.swift
//  project4
//
//  Created by Jesse viau on 2022-01-17.
//

import UIKit
import WebKit

// this class is a UIViewController extension that conforms to the WKNavigationDelegate Protocol
class ViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    var progresView: UIProgressView!
    var websites = ["apple.com", "hackingwithswift.com"]
    
    override func loadView(){
        
        /*
         
        Creating Webview from the class WKWebView, this is called
        instantiation, we're creating an instance of the WKWebView Class:
         */
        webView = WKWebView()
        
         /*
         A delegate is a way of writing code, in this scenario our
         delegate(WKWebView) informs us when the view controller changes:
          */
        webView.navigationDelegate = self
         
        /*
         Assigning view controller "view" to the WKWebView we just
         insantiated:
         */
        view = webView
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        //reloads the webview
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        //creates a new UIProgress view instance with a default style
        progresView = UIProgressView(progressViewStyle: .default)
        
        progresView.sizeToFit()
        
        //wrap the progress view in a bar button item to go into the toolbar
        let progressButton = UIBarButtonItem(customView: progresView)
        
        // an array that holds all of the toolbar items
        toolbarItems = [progressButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        
        /*
         
         KVO ( Key Value Observing )
         
         Observer - adding an observer allows us to know when the property of an object
         changes
         
         #keyPath - allows the compiler to check if your code is correct
         
         */
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        let url = URL(string: "https://" + websites[0])!
        
        // wraps our url in a URLRequest, swift doesn't open a url that came from a string, so therefore we have to pass it through a URLRequest function to allow the url to be parsed properly
        webView.load(URLRequest(url: url))
        // simply allows for a swipe feature to go back or forward depending on the direction.
        webView.allowsBackForwardNavigationGestures = true
    }

    @objc func openTapped(){
        let ac = UIAlertController(title: "Open Page", message: nil, preferredStyle: .actionSheet)
        //this lies within the open page button - will navigate to "apple.com"
        
//        ac.addAction(UIAlertAction(title: "apple.com", style: .default, handler: openPage))
//        // subset of the open page button - a link to "hackingwithswift.com"
//        ac.addAction(UIAlertAction(title: "hackingwithswift.com", style: .default, handler: openPage))
        
        //REFACTORED CODE
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        
        // a cancel button also a subset of the open page button
        ac.addAction(UIAlertAction(title: "cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(ac, animated: true)
    }
    
    
    /*
     
     openPage function:
     
     var actionTitle - gets the title ,returns if title is nil
     
     var url - concatenates https:// with the actionTitle value
     
     webView.load() - loads the parses URLRequest result into the webview
     
     this function takes care of getting the action.title which is a
     string concatenating https:// to the beginning to make it eligible to be
     passed through the URLRequest function to parse it as a website which is
     also forced loaded into the webview.
     
     */
    func openPage(action: UIAlertAction){
        guard let actionTitle = action.title else { return }
        guard let url = URL(string: "https://" + actionTitle) else { return }
        webView.load(URLRequest(url: url))
    }
    
    
    /*
     
     func webView:
     
     var title - simply sets the view controllers title to be the same as the webview title
     
     */
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    /*
     override func observeValue - notifiys the change if the keypath == to estimatedProgress to then set the progressView's progress to be that of the dynamic value of the estimatedProgress.
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progresView.progress = Float(webView.estimatedProgress)
        }
    }
    
    
    /*
     func webView - decides which url to allow and or cancel.
     
     var url - fetches the requested url
     
     var host - fetches the host of the url
     
     for loop - if the host contains one of the allowed websites inside of our websites array (apple.com, hackingwithswift.com) then the decisionHandler will be set to allow else it will be set to cancel.
     */
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        if let host = url?.host {
            for website in websites {
                if host.contains(website){
                    decisionHandler(.allow)
                    return
                }
            }
        }
        decisionHandler(.cancel)
    }
    
    
}

