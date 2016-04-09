//
//  WishListTableViewController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 1/22/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class WishListTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var wishList = [WishItem]()
    var wishProductsList = [BrandItem]()
    var imageCache = [String:UIImage]()
    let cellIdentifier = "WishItemViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad();
        tableView.delegate = self
        tableView.dataSource = self
        tableView.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        wishList = DBWishProductTable.SelectWish()
        if wishList.count == 0 {
            tableView.hidden = true
        }
        
        if wishList.count > wishProductsList.count {
            wishProductsList = [BrandItem]()
            RefreshTable()
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                for i in 0...self.wishList.count - 1 {
                    BrandItem().getBrandItemByID(self.wishList[i].productID, completeHandler: {(items) in
                        if items.count > 0 {
                            items[0].fullInitProduct({(brandItem) in
                                self.wishProductsList.append(brandItem)
                                dispatch_async(dispatch_get_main_queue()) {
                                    self.RefreshTable()
                                    self.tableView.hidden = false
                                }
                            })
                        }
                    })
                }
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishProductsList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! WishListViewCell
        let brandItem = wishProductsList[indexPath.row]
        
        cell.name.text = brandItem.getName()
        cell.itemProduct = brandItem
        cell.addToCartButton.tag = indexPath.row
        cell.photo.image = brandItem.getImage()
        cell.property.text = brandItem.getProductVariation().getName()
        cell.price.text = OrderController.sharedInstance().getCurrentOrderCurrency() + " " + String(brandItem.getPrice().definePrices)
        
        cell.addToCartButton.addTarget(self, action: "addToCartDialog:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.removeFromWish.tag = indexPath.row
        cell.removeFromWish.addTarget(self, action: "removeFromWishListAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell
    }
    
    var index = 0
    func addToCartDialog(sender: UIButton) {
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Add to cart", message: "Do you want add this product to your cart", preferredStyle: .Alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in}
        actionSheetController.view.tag = sender.tag
        actionSheetController.addAction(cancelAction)
        
        //Create and an option action
        let yesAction: UIAlertAction = UIAlertAction(title: "Yes", style: .Default) { action -> Void in
            if UserController.sharedInstance().isAnonimous() {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyBoard.instantiateViewControllerWithIdentifier("LoginNavigationController") as! UINavigationController
                self.presentViewController(viewController, animated: true, completion: nil)
            } else {
                OrderController.sharedInstance().getCurrentOrder()?.addProductToCart(self.wishProductsList[actionSheetController.view.tag].ID, completeHandler: {(orderedItem, message, error) in
                    OrderController.sharedInstance().UpdateUserOrder(UserController.sharedInstance().getUser()!.ID, completeHandler: {(successInit) in
                        dispatch_async(dispatch_get_main_queue()) {
                            self.removeFromWish(actionSheetController.view.tag)
                            self.RefreshTable()
                            self.tabBarController!.tabBar.items![2].badgeValue = String(OrderController.sharedInstance().getCurrentOrder()!.productItems.count)
                        }
                    })
                })
            }
        }
        actionSheetController.addAction(yesAction)
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
    func removeFromWishListAction(sender: UIButton) {
        removeFromWish(sender.tag)
        RefreshTable()
    }
    
    func removeFromWish(index: Int) {
        DBWishProductTable.RemoveItemFromWishList(wishList[index])
        wishList.removeAtIndex(index)
        wishProductsList.removeAtIndex(index)
        if wishList.count == 0 {
            self.tableView.hidden = true
        }
    }
    
    func RefreshTable() {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            return
        })
    }
    
}
