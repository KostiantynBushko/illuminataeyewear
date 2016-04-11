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
    
    private var successLogin: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
        self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(title: "Close", style: .Plain, target: self, action: "close:"), animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setSuccesLoginHandler(handler: () -> Void) {
        self.successLogin = handler
    }
    
    func close(target: AnyObject) {
        //self.dismissViewControllerAnimated(true, completion: nil)
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func createNewCustomer(sender: AnyObject) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let registeredNavigationController = storyBoard.instantiateViewControllerWithIdentifier("RegistrationViewController") as! RegistrationViewController
        registeredNavigationController.enableCloseButton = false
        self.navigationController?.pushViewController(registeredNavigationController, animated: true)
        
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
        UserController.sharedInstance().UserLogin(email.text!, password: password.text!, completeHandler: {(user, error   ) in
            if user != nil {
                dispatch_async(dispatch_get_main_queue()) {
                    //LiveCartController.startSession();
                    if user != nil {
                        OrderController.sharedInstance().UpdateUserOrder(UserController.sharedInstance().getUser()!.ID, completeHandler: {(successInit) in
                            dispatch_async(dispatch_get_main_queue()) {
                                self.dismissViewControllerAnimated(true, completion: nil)
                                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                                LiveCartController.TabBarUpdateBadgeValue((appDelegate.window?.rootViewController as! UITabBarController))
                                
                                if self.successLogin != nil {
                                    self.successLogin!()
                                }
                                let token = DBApnToken.GetToken()
                                if token != nil {
                                    //print(" User success login save token : " + token!)
                                    UserApnToken.SaveUserApnToken((user?.ID)!, token: token!, completeHandler: {() in})
                                }
                            }
                        })
                    }
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    self.showWarnimgMessage("Incorrect user name or password")
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

















