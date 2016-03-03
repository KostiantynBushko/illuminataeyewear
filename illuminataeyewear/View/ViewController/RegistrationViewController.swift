//
//  RegistrationViewController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/29/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    @IBOutlet var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(title: "Close", style: .Plain, target: self, action: "close:"), animated: true)
        
        webView.loadRequest(NSURLRequest(URL: NSURL(string: "http://www.illuminataeyewear.ca/user/register")!))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func close(target: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
