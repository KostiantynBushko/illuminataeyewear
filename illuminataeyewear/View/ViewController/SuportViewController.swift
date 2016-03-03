//
//  SuportViewController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 3/1/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class SuportViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(title: "Close", style: .Plain, target: self, action: "close:"), animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func close(target: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
