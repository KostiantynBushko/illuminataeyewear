//
//  UserAccountViewController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/12/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class UserAccountViewController: UIViewController {
    
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var email: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Account"
        let user = UserController.sharedInstance().getUser()
        if user != nil {
            self.firstName.text = user?.firstName
            self.lastName.text = user?.lastName
            self.email.text = user?.email
        }
        
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(title: "Log out", style: .Plain, target: self, action: "logOut:"), animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func logOut(target: AnyObject) {
        UserController.sharedInstance().UserLogOut({(success) in
            if success {
                print("Log out")
                /*let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.window?.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
                
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let liveCartViewController = storyBoard.instantiateViewControllerWithIdentifier("LiveCartViewController") as! LiveCartViewController
                appDelegate.window?.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
                appDelegate.window?.rootViewController? = liveCartViewController*/
                OrderController.sharedInstance().dropOrder()
                self.navigationController?.popViewControllerAnimated(true)
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                LiveCartController.TabBarUpdateBadgeValue((appDelegate.window?.rootViewController as! UITabBarController))
            }
        })
    }

}
