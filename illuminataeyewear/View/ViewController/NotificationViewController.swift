//
//  NotificationViewController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 3/6/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class NotificationViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    var notifications = [SimpleNotification]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(title: "Close", style: .Plain, target: self, action: #selector(NotificationViewController.close(_:))), animated: true)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        notifications = DBNotifications.GetNotification()
        RefreshTable()
        if(notifications.count > 0) {
            self.navigationItem.rightBarButtonItem = editButtonItem()
        }
        //print("Notification count : " + String(notifications.count))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func close(target: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NotificationViewCell", forIndexPath: indexPath) as! NotificationViewCell
        if !notifications[indexPath.row].new {
            cell.new.hidden = true
        }
        cell.message.text = notifications[indexPath.row].message
        cell.url.text = notifications[indexPath.row].url
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let notification = self.notifications[indexPath.row]
        let targetID = notification.targetID
        if notification.type == NotificatioinType.Url {
            if (notification.ID != nil) {
                self.tableView.reloadData()
                notification.new = false
            }
            UIApplication.sharedApplication().openURL(NSURL(string: notification.url)!)
        } else if notification.type == NotificatioinType.Product {
            let productID = notification.targetID
            let itemPageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ItemPageViewController") as? ItemPageViewController
            self.navigationController?.pushViewController(itemPageViewController!, animated: true)
            itemPageViewController?.InitwithProductID(productID)
        } else if notification.type == NotificatioinType.Category {
            let brandID = notification.targetID
            let itemsBrandTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ItemsBrandTableViewController") as? ItemsBrandTableViewController
            self.navigationController?.pushViewController(itemsBrandTableViewController!, animated: true)
            itemsBrandTableViewController?.initWithBrandID(brandID)
        } else if notification.type == NotificatioinType.UserMessage {
            let suportViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SuportViewController") as! SuportViewController
            suportViewController.orderID = targetID
            self.navigationController?.pushViewController(suportViewController, animated: true)
        } else if notification.type == NotificatioinType.Coupon || notification.type == NotificatioinType.SimpleMessage {
            let alert: UIAlertController = UIAlertController(title: "Message", message: notification.message, preferredStyle: .Alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Cancel) { action -> Void in}
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        notification.new = false
        self.tableView.reloadData()
        
        DBNotifications.MarkAsReaded(notification.ID)
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            dispatch_async(dispatch_get_main_queue()) {
                DBNotifications.removeNotification(self.notifications[indexPath.row].ID)
                self.notifications.removeAtIndex(indexPath.row)
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
        }
    }
    
    func RefreshTable() {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            return
        })
    }
}
