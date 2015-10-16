//
//  AboutViewController.swift
//  GoForIt
//
//  Created by Lidner on 10/16/15.
//  Copyright © 2015 Solfanto. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController, UIWebViewDelegate {
    
    var page: String?
    
    convenience init(page: String) {
        self.init()
        self.page = page
    }
    
    var webView = UIWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.webView)
        self.webView.alignTop("0", leading: "0", bottom: "0", trailing: "0", toView: self.view)
        
        self.navigationController?.navigationBar.translucent = false
        
        if self.navigationController?.viewControllers.count == 1 {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Done, target: self, action: "close:")
        }
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.webView.loadHTMLString(html(), baseURL: nil)
        self.webView.delegate = self
        
        self.title = "About"
    }
    
    // to override
    func html() -> String {
        return "<style>body {font-family: Arial;}</style><h1>About</h1><p>GoForIt! is an open source project. Please fork & contribute!</p><p><a href=\"https://github.com/Solfanto/GoForIt\">https://github.com/Solfanto/GoForIt</a></p>"
    }
    
    func close(sender: AnyObject?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == .LinkClicked {
            UIApplication.sharedApplication().openURL(request.URL!)
            return false
        }
        
        return true
    }
}
