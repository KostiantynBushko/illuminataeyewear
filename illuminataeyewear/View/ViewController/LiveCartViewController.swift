//
//  LiveCartViewController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/28/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class LiveCartViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        //super.viewDidAppear(animated)
        sleep(2)
        if Reachability.isConnectedToNetwork() == true {
            UserController.sharedInstance().getUserFromCurrentSession()
            LiveCartController.sharedInstance().startSession()
            SessionController.sharedInstance().GetSpecField(nil, reload: true)
        } else {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UIApplicationDelegate.applicationDidBecomeActive(_:)), name: UIApplicationDidBecomeActiveNotification, object: nil)
            let alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    override func applicationDidBecomeActive(notification: NSNotification?) {
        super.applicationDidBecomeActive(notification)
        if Reachability.isConnectedToNetwork() == true {
            UserController.sharedInstance().getUserFromCurrentSession()
            LiveCartController.sharedInstance().startSession()
            SessionController.sharedInstance().GetSpecField(nil, reload: true)
        }
    }
}
