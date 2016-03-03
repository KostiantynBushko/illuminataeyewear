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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var checkoutButton: UIBarButtonItem!
    @IBOutlet weak var emptyCart: UIScrollView!
    var isRunning: Bool = false
    var brandItems = [BrandItem]()
    var orderProductItems = [OrderProductItem]()
    
    let cellIdentifier = "OrderViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        isRunning = true
        tableView.hidden = true
        checkoutButton.enabled = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !UserController.sharedInstance().isAnonimous() {
            let order = OrderController.sharedInstance().getCurrentOrder()
            if order?.productItems.count == 0 {
                orderProductItems = [OrderProductItem]()
                brandItems = [BrandItem]()
                
                tableView.hidden = true
                emptyCart.hidden = false
                checkoutButton.enabled = false
                activityIndicator.stopAnimating()
                LiveCartController.TabBarUpdateBadgeValue(self.tabBarController!);
                
            } else if order?.productItems.count > orderProductItems.count {
                checkoutButton.enabled = false
                tableView.hidden = true
                emptyCart.hidden = true
                activityIndicator.startAnimating()
                
                orderProductItems = [OrderProductItem]()
                brandItems = [BrandItem]()
                
                if order?.productItems.count > 0 {
                    LiveCartController.TabBarUpdateBadgeValue(self.tabBarController!)
                    orderProductItems = (order?.productItems)!
                    for itemProduct in (order?.productItems)! {
                        BrandItem().getBrandItemByID(itemProduct.productID, completeHandler: {(items) in
                            items[0].fullInitProduct({(brandItem) in
                                self.brandItems.append(brandItem)
                                self.activityIndicator.stopAnimating()
                                if self.brandItems.count == self.orderProductItems.count {
                                    dispatch_async(dispatch_get_main_queue()) {
                                        self.checkoutButton.enabled = true
                                    }
                                }
                                self.RefreshTable()
                            })
                        })
                    }
                }
            } else if order?.productItems.count == orderProductItems.count {
                orderProductItems = (order?.productItems)!
                self.RefreshTable()
            }
            
            self.navigationItem.leftBarButtonItem = editButtonItem()
        }
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(false)
        isRunning = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return brandItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! OrderViewCell
        
        let brandItem = brandItems[indexPath.row]
        let orderProductItem = self.orderProductItems[indexPath.row]
        let price = Float(brandItem.getPrice().definePrices)
        
        cell.name.text = brandItem.getName()
        cell.price.text = String(orderProductItems[indexPath.row].count) + String(" x ") + brandItem.getPrice().definePrices
        cell.photo.image = brandItem.image
        //cell.quantity.text = String(orderProductItems[indexPath.row].count)
        cell.property.text = brandItem.getProductVariation().getName()
        cell.cost.text = OrderController.sharedInstance().getCurrentOrderCurrency() + " " + String(Float(orderProductItem.count) * price!)
        
        return cell
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
            let orderID = OrderController.sharedInstance().getCurrentOrder()?.ID
            Order.deleteItemFormCart(self.orderProductItems[indexPath.row].ID, orderID: orderID!, completeHandler: {() in
                OrderController.sharedInstance().UpdateUserOrder((UserController.sharedInstance().getUser()?.ID)!, completeHandler: {(success) in
                    dispatch_async(dispatch_get_main_queue()) {
                        self.brandItems.removeAtIndex(indexPath.row)
                        self.orderProductItems = (OrderController.sharedInstance().getCurrentOrder()?.productItems)!
                        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                        LiveCartController.TabBarUpdateBadgeValue(self.tabBarController!)
                    }
                })
            })
        }
    }
    
    @IBAction func checkoutAction(sender: AnyObject) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let checkoutNavigationController = storyboard.instantiateViewControllerWithIdentifier("CheckoutNavigationController") as! UINavigationController
        self.presentViewController(checkoutNavigationController, animated: true, completion: nil)
    }
    
    
    func RefreshTable() {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.hidden = false
            self.tableView.reloadData()
            return
        })
    }
}











