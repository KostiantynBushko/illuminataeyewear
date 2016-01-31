//
//  NewsDetailsViewController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 1/26/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class NewsDetailsViewController: UIViewController, UIWebViewDelegate {
    
    
    var frameHtml = String()
    var image = UIImage()
    var textHtml = String()
    

    @IBOutlet weak var iFrame: UIWebView!
    @IBOutlet weak var moreText: UIWebView!
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !(frameHtml as NSString).isEqualToString("") {
            imageView.hidden = true
            iFrame.loadHTMLString(frameHtml, baseURL: nil)
            iFrame.scrollView.scrollEnabled = false
            iFrame.scrollView.bounces = false
        } else {
            iFrame.hidden = true
            imageView.image = image
        }
        moreText.loadHTMLString(textHtml, baseURL: NSURL(string: Constant.URL_BASE))
        moreText.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let url = request.URL where navigationType == UIWebViewNavigationType.LinkClicked {
            UIApplication.sharedApplication().openURL(url)
            return false
        }
        return true
    }
}
