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
    
    var items = ["MY ACOOUNT","MY TRANSACTIONS","CONTACT US","ABOUT US"]
    var icons = ["person_black_18p","receipt_black_18p","chat_black_18p","info_black_18p"]
    
    let MY_ACOOUNT = 0
    let MY_TRANSACTIONS = 1
    let CONTACT_US = 2
    let ABOUT_US = 3
    
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
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyBoard.instantiateViewControllerWithIdentifier("LoginNavigationController") as! UINavigationController
                self.presentViewController(viewController, animated: true, completion: nil)
            } else {
                let accountViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserAccountViewController") as! UserAccountViewController
                self.navigationController?.pushViewController(accountViewController, animated: true)
            }
            
        } else if indexPath.row == MY_TRANSACTIONS {
            let transactionViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserTransactionTableViewController") as! UserTransactionTableViewController
            self.navigationController?.pushViewController(transactionViewController, animated: true)
        
        } else if indexPath.row == CONTACT_US {
            let contactViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ContactsViewController") as! ContactsViewController
            self.navigationController?.pushViewController(contactViewController, animated: true)
            
        } else if indexPath.row == ABOUT_US {
            let aboutViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AboutViewController") as! AboutViewController
            self.navigationController?.pushViewController(aboutViewController, animated: true)
        }
    }
    
}
