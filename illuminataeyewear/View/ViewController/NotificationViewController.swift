//
//  NotificationViewController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 3/6/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    var notifications = [SimpleNotification]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(title: "Close", style: .Plain, target: self, action: "close:"), animated: true)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        notifications = DBNotifications.GetNotification()
        RefreshTable()
        print("Notification count : " + String(notifications.count))
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
        }
        
        DBNotifications.MarkAsReaded(notification.ID)
    }
    
    func RefreshTable() {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            return
        })
    }
}
