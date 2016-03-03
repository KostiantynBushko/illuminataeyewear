//
//  TransactionDetailViewController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/29/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class TransactionDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var order: Order?
    var transaction: Transaction?

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        if order != nil {
            self.title = order?.invoiceNumber
            Transaction.GetTransactionByOrderID((self.order?.ID)!, completeHandler: {(transactions) in
                if transactions.count > 0 {
                    self.transaction = transactions[0]
                }
            })
            
            self.navigationItem.setRightBarButtonItem(UIBarButtonItem(title: "Suport", style: .Plain, target: self, action: "suport:"), animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func suport(target: AnyObject) {
        print("Run support view controller")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let suportNavigationController = storyBoard.instantiateViewControllerWithIdentifier("SuportNavigationController") as! UINavigationController
        self.presentViewController(suportNavigationController, animated: true, completion: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.order != nil {
            return (self.order?.productItems.count)!
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TransactionDetailProductCell", forIndexPath: indexPath) as! TransactionDetailProductCell
        cell.name.text = self.order?.productItems[indexPath.row].name
        cell.SKU.text = self.order?.productItems[indexPath.row].sku
        cell.price.text = String(self.order!.currencyID) + " " + String(self.order!.productItems[indexPath.row].price)
        cell.quantity.text = String(self.order!.productItems[indexPath.row].count)
        let subtotal = Float32(self.order!.productItems[indexPath.row].price) * Float32(self.order!.productItems[indexPath.row].count)
        cell.subtotal.text = String(self.order!.currencyID) + " " + String(subtotal)
        return cell
    }
}
