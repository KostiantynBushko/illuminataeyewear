//
//  LoginViewController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 1/12/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class LoginViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func Login(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewControllerWithIdentifier("MainTabBarController")
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = tabBarController
    }
}
