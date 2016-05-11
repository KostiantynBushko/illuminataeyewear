//
//  UserAccountViewController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/12/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class UserAccountViewController: BaseViewController {
    
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
        
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(title: "Log out", style: .Plain, target: self, action: #selector(UserAccountViewController.logOut(_:))), animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func logOut(target: AnyObject) {
        let alert: UIAlertController = UIAlertController(title: "Alert!", message: "Do you want to completely log out from the app? you won't be available to place an order!", preferredStyle: .Alert)
        
        let yesAction: UIAlertAction = UIAlertAction(title: "No", style: .Default) { action -> Void in}
        
        alert.addAction(yesAction)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Yes", style: .Cancel) { action -> Void in
            UserController.sharedInstance().UserLogOut({(success) in
                if success {
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
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

}
