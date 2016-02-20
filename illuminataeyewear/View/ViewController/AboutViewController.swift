//
//  AboutViewController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/18/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.loadRequest(NSURLRequest(URL: NSURL(string: Constant.URL_ABOUT_PAGE)!))
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
