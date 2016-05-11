//
//  SuportViewController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 3/1/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class SuportViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate {

    @IBOutlet var text: UITextField!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var viewContainer: UIView!
    
    var orderID: Int64?
    var orderNotes = [OrderNote]()
    var cellHeight = [Int:CGFloat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.text.inputAccessoryView = toolBarButtonDone(0)
        self.text.delegate = self
        
        if self.orderID != nil {
            OrderNote().GetOrderNote(self.orderID!, completeHandler: {(notes, message, error)in
                if error == nil {
                    self.orderNotes = notes
                    self.RefreshTable()
                }
            })
        }
        //self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(title: "Close", style: .Plain, target: self, action: "close:"), animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BrandItemViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BrandItemViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.scrollView.frame.size.height -= keyboardSize.height
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.scrollView.frame.size.height += keyboardSize.height
        }
    }
    
    private func toolBarButtonDone(tag: Int) -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SuportViewController.done(_:)))
        doneButton.tag = tag
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        return toolBar
    }
    
    func close(target: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderNotes.count
    }
    
    func done(sender: UIBarButtonItem) {
        self.text.resignFirstResponder()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TextMessageViewCell", forIndexPath: indexPath) as! TextMessageViewCell
        cell.message.text = " " + self.orderNotes[indexPath.row].text.htmlDecoded() + " "
        cell.message.numberOfLines = 0
        cell.message.sizeToFit()
        if self.orderNotes[indexPath.row].isAdmin {
            cell.from.text = "support:"
            cell.message.textAlignment = .Left
        } else {
            cell.from.text = "me:"
            cell.message.textAlignment = .Right
        }
        cell.time.text = self.orderNotes[indexPath.row].time
        self.cellHeight[indexPath.row] = cell.message.frame.height + 60
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var h = self.cellHeight[indexPath.row]
        if h == nil {
            h = 0
        }
        return h!
    }
    
    // Text field delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if self.text.text?.isEmpty == false && self.orderID != nil {
            OrderNote().SendMessage(self.orderID!, message: self.text.text!, completeHandler: {(notes, message, error) in
                if error == nil {
                    self.orderNotes.append(notes[0])
                    self.RefreshTable()
                    dispatch_async(dispatch_get_main_queue()) {
                        self.text.text = ""
                        let lastIndex = NSIndexPath(forRow: self.orderNotes.count - 1, inSection: 0)
                        self.tableView.scrollToRowAtIndexPath(lastIndex, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
                    }
                }
            })
        }
        textField.resignFirstResponder()
        return true
    }
    
    func RefreshTable() {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            if self.orderNotes.count > 0 {
                let lastIndex = NSIndexPath(forRow: self.orderNotes.count - 1, inSection: 0)
                self.tableView.scrollToRowAtIndexPath(lastIndex, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            }
            return
        })
    }
}
