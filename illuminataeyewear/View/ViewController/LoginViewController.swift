//
//  LoginViewController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 1/12/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class LoginViewController : UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        email.hidden = true
        password.hidden = true
        logInButton.hidden = true
        
        if getUserFromCurrentSession() {
            startSession()
        } else {
            email.hidden = false
            password.hidden = false
            logInButton.hidden = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func Login(sender: UIButton) {
        User.UserLogIn(email.text!, password: password.text!, completeHandler: {(user) in
            if user != nil {
                DBUserTable.SaveUser(user!)
                UserController.sharedInstance().setUser(user!)
                dispatch_async(dispatch_get_main_queue()) {
                    self.startSession()
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    self.showWarnimgMessage("Incorrect user name or password")
                }
            }
        })
    }
    
    func getUserFromCurrentSession() -> Bool {
        let user = DBUserTable.GetCurrentUser()
        if (user != nil) {
            UserController.sharedInstance().setUser(user!)
            return true
        }
        return false
    }
    
    private func startSession() {
        OrderController.sharedInstance().UpdateUserOrder(UserController.sharedInstance().getUser().ID, completeHandler: {(successInit) in
            dispatch_async(dispatch_get_main_queue()) {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tabBarController = storyboard.instantiateViewControllerWithIdentifier("MainTabBarController") as! UITabBarController
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.window?.rootViewController = tabBarController
                
                let cartItemCount = OrderController.sharedInstance().getCurrentOrder()!.productItems.count
                if cartItemCount > 0 {
                    tabBarController.tabBar.items![2].badgeValue = String(cartItemCount)
                }
            }
        })
    }
    
    func showWarnimgMessage(message: String) {
        let actionSheetController: UIAlertController = UIAlertController(title: "Warning", message: message, preferredStyle: .Alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in}
        actionSheetController.addAction(cancelAction)
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
}
