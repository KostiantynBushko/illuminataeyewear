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
        let order = OrderController.sharedInstance().getCurrentOrder()
        
        if order?.productItems.count == 0 {
            orderProductItems = [OrderProductItem]()
            brandItems = [BrandItem]()
            
            tableView.hidden = true
            emptyCart.hidden = false
            checkoutButton.enabled = false
            activityIndicator.stopAnimating()
            self.tabBarController!.tabBar.items![2].badgeValue = nil
            
        } else if order?.productItems.count > orderProductItems.count {
            checkoutButton.enabled = false
            tableView.hidden = true
            emptyCart.hidden = true
            activityIndicator.startAnimating()
            
            orderProductItems = [OrderProductItem]()
            brandItems = [BrandItem]()
            //self.RefreshTable();
            if order?.productItems.count > 0 {
                self.tabBarController!.tabBar.items![2].badgeValue = String(OrderController.sharedInstance().getCurrentOrder()!.productItems.count)
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
