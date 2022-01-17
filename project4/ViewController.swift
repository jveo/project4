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

    var webview: WKWebView!
    
    override func loadView(){
        
        /*
         
        Creating Webview from the class WKWebView, this is called
        instantiation, we're creating an instance of the WKWebView Class:
         */
        webview = WKWebView()
        
         /*
         A delegate is a way of writing code, in this scenario our
         delegate(WKWebView) informs us when the view controller changes:
          */
        webview.navigationDelegate = self
         
        /*
         Assigning view controller "view" to the WKWebView we just
         insantiated:
         */
        view = webview
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://www.hackingwithswift.com")!
        // wraps our url in a URLRequest, swift doesn't open a url that came from a string, so therefore we have to pass it through a URLRequest function to allow the url to be parsed properly
        webview.load(URLRequest(url: url))
        // simply allows for a swipe feature to go back or forward depending on the direction.
        webview.allowsBackForwardNavigationGestures = true
    }


}

