//
//  RegistrationViewController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/29/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController, BusyAlertDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var firstName: UITextField!
    @IBOutlet var lastName: UITextField!
    @IBOutlet var company: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var pass_one: UITextField!
    @IBOutlet var pass_two: UITextField!
    
    var busyAlertController: BusyAlert?
    
    var enableCloseButton: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
     
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if enableCloseButton {
            self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(title: "Close", style: .Plain, target: self, action: "close:"), animated: true)
        }
        busyAlertController = BusyAlert(title: "", message: "", button: "OK", presentingViewController: self)
        busyAlertController?.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func close(target: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            scrollView.frame.size.height -= keyboardSize.height
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            scrollView.frame.size.height += keyboardSize.height
        }
    }
    

    var successRegistered: Bool = false
    var successLogin: Bool = false
    
    @IBAction func completeRegistration(sender: AnyObject) {
        if checkRequiredField() == false {
            let userAlert = UIAlertController(title: "Warning", message: "Please complete all required fields", preferredStyle: UIAlertControllerStyle.Alert)
            userAlert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(userAlert, animated: true, completion: nil)
        } else {
            busyAlertController = nil
            busyAlertController = BusyAlert(title: "", message: "", button: "OK", presentingViewController: self)
            busyAlertController?.delegate = self
            busyAlertController?.display()
            User.EmailAlreadyExist(self.email.text!, completeHandler: {(exist, error) in
                if !exist {
                    //Create new customer
                    User.UserRegistered(self.email.text!, pass: self.pass_one.text!, firstName: self.firstName.text!, lastName: self.lastName.text!, company: self.company.text!, completeHandler: {(success, error) in
                        guard let _:Bool = success where error == nil else {
                            self.busyAlertController?.message = (error?.localizedDescription)!
                            dispatch_async(dispatch_get_main_queue()) {
                                self.busyAlertController?.finish()
                            }
                            return
                        }
                        self.busyAlertController?.message = "Registration is successful"
                        self.successRegistered = true
                        dispatch_async(dispatch_get_main_queue()) {
                            self.busyAlertController?.finish()
                        }
                    })
                } else {
                    self.busyAlertController?.message = "Email " + self.email.text! + " already exist"
                    dispatch_async(dispatch_get_main_queue()) {
                        self.busyAlertController?.finish()
                    }
                }
            })
        }
    }
    
    
    private func checkRequiredField() -> Bool {
        if !(firstName.text!.isEmpty || lastName.text!.isEmpty || email.text!.isEmpty || pass_one.text!.isEmpty || pass_two.text!.isEmpty) {
            return true
        }
        return false
    }
    
    func didCancelBusyAlert() {
        print("Cancell")
        if successRegistered {
            successRegistered = false
            UserController.sharedInstance().UserLogin(email.text!, password: self.pass_one.text!, completeHandler: {(user, error) in
                if user != nil {
                    dispatch_async(dispatch_get_main_queue()) {
                        //LiveCartController.startSession();
                        if user != nil {
                            OrderController.sharedInstance().UpdateUserOrder(UserController.sharedInstance().getUser()!.ID, completeHandler: {(successInit) in
                                dispatch_async(dispatch_get_main_queue()) {
                                    //self.dismissViewControllerAnimated(true, completion: nil)
                                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                                    LiveCartController.TabBarUpdateBadgeValue((appDelegate.window?.rootViewController as! UITabBarController))
                                    
                                    let token = DBApnToken.GetToken()
                                    if token != nil {
                                        print(" User success login save token : " + token!)
                                        UserApnToken.SaveUserApnToken((user?.ID)!, token: token!, completeHandler: {() in})
                                    }
                                    self.successLogin = true
                                    self.busyAlertController?.message = "Login is successful"
                                    self.busyAlertController?.finish()
                                }
                            })
                        }
                    }
                } else {
                    self.busyAlertController?.message = "Login"
                    self.busyAlertController?.finish()
                }
            })
            busyAlertController = nil
            busyAlertController = BusyAlert(title: "", message: "", button: "OK", presentingViewController: self)
            busyAlertController?.delegate = self
            busyAlertController?.display()
        } else if successLogin {
            dispatch_async(dispatch_get_main_queue()) {
                let product = SessionController.sharedInstance().GetProduct()
                let productOptionChoice = SessionController.sharedInstance().GetOption()
                let optionsText = SessionController.sharedInstance().GetOptionText()
                print("ALL SELECTED OPTIONS : " + String(optionsText))
                if product != nil {
                    OrderController.sharedInstance().getCurrentOrder()?.addProductToCart(product!, completeHandler: {(orderedItem, message, error) in
                        
                        if productOptionChoice != nil {
                            for optionChoice in productOptionChoice! {
                                print("OPTION TEXT : " + String(optionsText[optionChoice.1.ID]))
                                OrderedItemOption().SetOrderedItemOption(orderedItem[0].ID, productOptionChoice: optionChoice.1.ID, optionText: optionsText[optionChoice.1.ID], completeHandler: {(options, message, error) in
                                })
                            }
                        }
                        
                        OrderController.sharedInstance().UpdateUserOrder(UserController.sharedInstance().getUser()!.ID, completeHandler: {(successInit) in
                            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                            LiveCartController.TabBarUpdateBadgeValue((appDelegate.window?.rootViewController as! UITabBarController))
                            if OrderController.sharedInstance().getCurrentOrder()?.productItems.count > 0 {
                                dispatch_async(dispatch_get_main_queue()) {
                                    self.dismissViewControllerAnimated(true, completion: nil)
                                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                    let viewController = storyBoard.instantiateViewControllerWithIdentifier("AddressNavigationController") as! UINavigationController
                                    appDelegate.window?.rootViewController?.presentViewController(viewController, animated: true, completion: nil)
                                }
                            } else {
                                dispatch_async(dispatch_get_main_queue()) {
                                    self.dismissViewControllerAnimated(true, completion: nil)
                                }
                            }
                        })
                    })
                    
                    
                    //self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }
    }
}
