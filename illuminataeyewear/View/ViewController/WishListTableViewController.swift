//
//  WishListTableViewController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 1/22/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class WishListTableViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var wishList = [WishItem]()
    var wishProductsList = [BrandItem]()
    var imageCache = [String:UIImage]()
    let cellIdentifier = "WishItemViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad();
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        wishList = DBWishProductTable.SelectWish()
        if wishList.count == 0 {
            //self.tableView.hidden = true
        } else {
            self.navigationItem.rightBarButtonItem = editButtonItem()
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
                                    //self.tableView.hidden = false
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
        if self.wishProductsList.count > 0 {
            self.tableView.separatorStyle = .SingleLine
            return 1
        } else {
            let label: UILabel = UILabel()
            label.frame = CGRectMake(100, 0, self.view.bounds.size.width - 100, self.view.bounds.size.height)
            label.text = "Your wish list currently is empty, please go to the catalog to start shopping"
            label.numberOfLines = 0
            label.textColor = UIColor.grayColor()
            label.font = label.font.fontWithSize(15)
            label.textAlignment = .Center
            label.sizeToFit()
            self.tableView.backgroundView = label
            self.tableView.separatorStyle = .None
        }
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
        
        cell.addToCartButton.addTarget(self, action: #selector(WishListTableViewController.addToCartDialog(_:)), forControlEvents: UIControlEvents.TouchUpInside)

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
            //self.tableView.hidden = true
            self.navigationItem.rightBarButtonItem = nil
        }
        LiveCartController.TabBarUpdateWishBadgeValue(self.tabBarController!)
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            dispatch_async(dispatch_get_main_queue()) {
                //DBNotifications.removeNotification(self.notifications[indexPath.row].ID)
                //self.notifications.removeAtIndex(indexPath.row)
                self.removeFromWish(indexPath.row)
                //self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
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
