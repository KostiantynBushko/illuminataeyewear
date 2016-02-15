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
    @IBOutlet weak var scrollView: UIScrollView!
    
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    var isShowKeyboard = false
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if isShowKeyboard == false {
                scrollView.frame.size.height -= keyboardSize.height
                isShowKeyboard = true
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            scrollView.frame.size.height += keyboardSize.height
            isShowKeyboard = false
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
        OrderController.sharedInstance().UpdateUserOrder(UserController.sharedInstance().getUser()!.ID, completeHandler: {(successInit) in
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
