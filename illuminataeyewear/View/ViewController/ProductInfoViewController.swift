//
//  ProductInfoViewController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 3/6/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class ProductInfoViewController: UIViewController, UIWebViewDelegate  {
    
    @IBOutlet var photo: UIImageView!
    @IBOutlet var webView: UIWebView!
    
    var brandItem: BrandItem?
    var isRunning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isRunning = true
        self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "close:"), animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "close:"), animated: true)
        
        if brandItem != nil {
            if brandItem?.getImage() == nil {
                brandItem?.getDefaultImage({(success) in
                    if self.isRunning {
                        if self.brandItem?.getImage() != nil {
                            dispatch_async(dispatch_get_main_queue()) {
                                self.photo.image = self.brandItem?.getImage()
                            }
                        }
                    }
                })
            } else {
                self.photo.image = self.brandItem?.getImage()
            }
            
            self.title = brandItem?.getProductCodeName()
            webView.loadHTMLString((self.brandItem?.longDescription)!, baseURL: NSURL(string: Constant.URL_BASE))
            webView.delegate = self
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        isRunning = false
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let url = request.URL where navigationType == UIWebViewNavigationType.LinkClicked {
            UIApplication.sharedApplication().openURL(url)
            return false
        }
        return true
    }
    
    func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
