//
//  ProductInfoViewController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 3/6/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class ProductInfoViewController: BaseViewController, UIWebViewDelegate  {
    
    @IBOutlet var photo: UIImageView!
    @IBOutlet var webView: UIWebView!
    
    var brandItem: BrandItem?
    var isRunning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isRunning = true
        self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(ProductInfoViewController.close(_:))), animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(ProductInfoViewController.close(_:))), animated: true)
        
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
            
            var productID = Int64()
            if brandItem?.parentBrandItem == nil {
                productID = (self.brandItem?.ID)!
            } else {
                productID = (brandItem?.parentBrandItem?.ID)!
            }
            SpecificationStringValue().GetSpecifucationStringValueList(productID, completeHandler:{(stringValues, message, error) in
                if error == nil {
                    SessionController.sharedInstance().GetSpecField({(specField)in
                        if specField.count > 0 {
                            var specification = String()
                            for value in stringValues {
                                if !(value.value.isEmpty) && (value.specFieldID == 1 || value.specFieldID == 8 || value.specFieldID == 13 || value.specFieldID == 12 || value.specFieldID == 9) {
                                    specification.appendContentsOf("<p><h2>")
                                    specification.appendContentsOf((specField[value.specFieldID]?.name)!)
                                    specification.appendContentsOf("</p></h2>")
                                    specification.appendContentsOf("<p>")
                                    specification.appendContentsOf(value.value)
                                    specification.appendContentsOf("</p>")
                                }
                            }
                            dispatch_async(dispatch_get_main_queue()) {
                                var description = String()
                                description.appendContentsOf((self.brandItem?.longDescription)!)
                                description.appendContentsOf(specification)
                                self.webView.loadHTMLString(description, baseURL: NSURL(string: Constant.URL_BASE))
                            }
                        }
                    }, reload:false)
                }
            })
            
            self.title = brandItem?.getName()
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
