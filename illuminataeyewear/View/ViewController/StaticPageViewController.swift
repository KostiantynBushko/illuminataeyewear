//
//  StaticPageViewController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 4/8/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class StaticPageViewController: BaseViewController, UIWebViewDelegate {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var viewContainer: UIView!
    @IBOutlet var webView: UIWebView!
    
    var staticPageID: Int64?
    var staticPage: StaticPage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
        // Do any additional setup after loading the view.
        if self.staticPageID != nil {
            StaticPage().GetStaticPage(self.staticPageID!, completeHandler: {(pages, message, error) in
                if error == nil {
                    self.staticPage = pages[0]
                    dispatch_async(dispatch_get_main_queue()) {
                        self.title = self.staticPage?.title
                        self.webView.loadHTMLString((self.staticPage?.text)!, baseURL: NSURL(string: Constant.URL_BASE))
                        self.webView.delegate = self
                    }
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let url = request.URL where navigationType == UIWebViewNavigationType.LinkClicked {
            UIApplication.sharedApplication().openURL(url)
            return false
        }
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
