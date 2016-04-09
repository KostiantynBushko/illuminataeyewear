//
//  LiveCartViewController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/28/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class LiveCartViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        sleep(5)
        if Reachability.isConnectedToNetwork() == true {
            UserController.sharedInstance().getUserFromCurrentSession()
            LiveCartController.sharedInstance().startSession()
        } else {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationDidBecomeActive:", name: UIApplicationDidBecomeActiveNotification, object: nil)
            let alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    func applicationDidBecomeActive(notification: NSNotification?) {
        if Reachability.isConnectedToNetwork() == true {
            UserController.sharedInstance().getUserFromCurrentSession()
            LiveCartController.sharedInstance().startSession()
        } else {
            let alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
}
