//
//  UserTransactionTableViewController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/18/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class UserTransactionTableViewController: BaseTableViewController {
    
    var orders = [Order]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Orders"
        Order.GetOrdersList((UserController.sharedInstance().getUser()?.ID)!, isFinalised: true, completeHandler: {(ordersList) in
            self.orders = ordersList!
            self.RefreshTable()
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TransactionViewCell", forIndexPath: indexPath) as! TransactionViewCell
        let order = orders[indexPath.row]
        cell.order_id.text = order.invoiceNumber
        cell.recipient.text = String(order.User_firstName) + " " + String(order.User_lastName)
        var total: String = order.getCurrency()
        total.appendContentsOf(" ")
        total.appendContentsOf(String(format: "%.2f", order.capturedAmount))
        cell.total.text = total
        
        if order.isCancelled {
            cell.status.textColor = UIColor.redColor()
            cell.status.text = " Cancelled"
        } else if order.isPaid {
            cell.status.textColor = UIColor.greenColor()
            cell.status.text = "The order is being processed"
        } else {
            if order.status == -1 || order.status == 2 || (order.status == 0 && !order.isPaid && !order.isCancelled){
                cell.status.textColor = UIColor.blueColor()
                cell.status.text = "Awaiting payment"
            }
        }
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "TransactionDetailSegue" {
            let transactionDetailViewController = segue.destinationViewController as! TransactionDetailViewController
            if let indexPath : NSIndexPath = self.tableView.indexPathForSelectedRow! {
                transactionDetailViewController.order = self.orders[indexPath.row]
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
