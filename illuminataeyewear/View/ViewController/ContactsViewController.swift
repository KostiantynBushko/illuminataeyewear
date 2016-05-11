//
//  ContactsViewController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/12/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit
import MessageUI

class ContactsViewController: BaseViewController, MFMailComposeViewControllerDelegate, UITextViewDelegate {
    
    @IBOutlet weak var emailMessage: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "CONTACT US"
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
        emailMessage.layer.borderColor = UIColor.lightGrayColor().CGColor
        emailMessage.layer.borderWidth = 0.5
        emailMessage.layer.cornerRadius = 5
        
        emailMessage.delegate = self
    }
    
    // MARK: UITextViewDelegate
    func textViewDidBeginEditing(textView: UITextView) {
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(ContactsViewController.hideKeyboard(_:))), animated: false)
        let scrollPoint : CGPoint = CGPointMake(0, self.emailMessage.frame.origin.y - 20)
        self.scrollView.setContentOffset(scrollPoint, animated: true)
    }
    func textViewDidEndEditing(textView: UITextView) {
        self.scrollView.setContentOffset(CGPointZero, animated: true)
    }
    
    /*func keyboardWillShow(notification: NSNotification) {
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "hideKeyboard:"), animated: false)
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            scrollView.frame.size.height -= keyboardSize.height
        }
    }
    
    
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            scrollView.frame.size.height += keyboardSize.height
        }
    }*/
    
    
    
    func hideKeyboard(sender: AnyObject) {
        self.navigationItem.rightBarButtonItem = nil
        emailMessage.endEditing(true)
    }
    
    @IBAction func submitAction(sender: AnyObject) {
        let mailComposeViewController = configureMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
        }
    }
    
    func configureMailComposeViewController() -> MFMailComposeViewController {
        let mailComposeViewController = MFMailComposeViewController()
        mailComposeViewController.mailComposeDelegate = self
        mailComposeViewController.setToRecipients(["sales@illuminataeyewear.com "])
        mailComposeViewController.setSubject("From illuminata mobile app e-mail")
        mailComposeViewController.setMessageBody(emailMessage.text, isHTML: false)
        return mailComposeViewController
    }
    
    /*func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }*/
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}
