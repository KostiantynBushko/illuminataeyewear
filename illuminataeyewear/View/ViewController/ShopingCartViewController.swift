//
//  ShopingCartViewController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 1/30/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class ShopingCartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var order = Order()
    let cellIdentifier = "OrderViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        Order.getOrder(40, completeHandler: {(ordersList) in
            self.order = ordersList[0]
            self.RefreshTable()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order.productItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! OrderViewCell
        
        //cell.name.text = order.productItems[indexPath.row].name
        
        return cell
    }
    
    func RefreshTable() {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            return
        })
    }
    
}
