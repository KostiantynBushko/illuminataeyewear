//
//  MoreTableViewController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/3/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class MoreTableViewController: UITableViewController {

    let cellIdentifier = "MoreViewCell"
    
    var items = ["MY ACOOUNT","MY TRANSACTIONS","CONTACT US","ABOUT US", "SHIPPING POLICY","RETURN POLICY","PRIVACY POLICY","HOURS OF OPERATION"]
    var icons = ["person_black_18p","receipt_black_18p","chat_black_18p","info_black_18p","local_shipping_black_18","shop_two_black_18p","lock_outline_18p","access_time_black_18p"]
    
    let MY_ACOOUNT = 0
    let MY_TRANSACTIONS = 1
    let CONTACT_US = 2
    let ABOUT_US = 3
    let SHIPPING_POLICY = 4
    let RETURN_POLICY = 5
    let HOURS_OPERATION = 7
    let PRIVACY_POLICY = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MoreViewCell
        cell.label.text = items[indexPath.row]
        cell.icon.image = UIImage(named: icons[indexPath.row])
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == MY_ACOOUNT {
            if UserController.sharedInstance().isAnonimous() {
                self.StartLoginView()
            } else {
                let accountViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserAccountViewController") as! UserAccountViewController
                self.navigationController?.pushViewController(accountViewController, animated: true)
            }
            
        } else if indexPath.row == MY_TRANSACTIONS {
            if UserController.sharedInstance().isAnonimous() {
                StartLoginView()
            } else {
                let transactionViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserTransactionTableViewController") as! UserTransactionTableViewController
                self.navigationController?.pushViewController(transactionViewController, animated: true)
            }
        } else if indexPath.row == CONTACT_US {
            let contactViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ContactsViewController") as! ContactsViewController
            self.navigationController?.pushViewController(contactViewController, animated: true)
            
        } else if indexPath.row == ABOUT_US {
            let aboutViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AboutViewController") as! AboutViewController
            self.navigationController?.pushViewController(aboutViewController, animated: true)
        
        } else if indexPath.row == SHIPPING_POLICY {
            let staticPageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("StaticPageViewController") as! StaticPageViewController
            staticPageViewController.staticPageID = 2
            self.navigationController?.pushViewController(staticPageViewController, animated: true)
        } else if indexPath.row == RETURN_POLICY {
            let staticPageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("StaticPageViewController") as! StaticPageViewController
            staticPageViewController.staticPageID = 12
            self.navigationController?.pushViewController(staticPageViewController, animated: true)
        } else if indexPath.row == HOURS_OPERATION {
            let staticPageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("StaticPageViewController") as! StaticPageViewController
            staticPageViewController.staticPageID = 10
            self.navigationController?.pushViewController(staticPageViewController, animated: true)
        } else if indexPath.row == PRIVACY_POLICY {
            let staticPageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("StaticPageViewController") as! StaticPageViewController
            staticPageViewController.staticPageID = 15
            self.navigationController?.pushViewController(staticPageViewController, animated: true)
        }
    }
    
    private func StartLoginView() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewControllerWithIdentifier("LoginNavigationController") as! UINavigationController
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
}
