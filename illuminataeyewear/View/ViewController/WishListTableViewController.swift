//
//  WishListTableViewController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 1/22/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class WishListTableViewController: UITableViewController {
    
    var wishList = [WishItem]()
    var wishProductsList = [BrandItem]()
    var imageCache = [String:UIImage]()
    let cellIdentifier = "WishItemViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    override func viewDidAppear(animated: Bool) {
        wishList = DBWishProductTable.SelectWish()
        if wishList.count > wishProductsList.count {
            wishProductsList = [BrandItem]()
            RefreshTable()
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                for i in 0...self.wishList.count - 1 {
                    BrandItem.getBrandItemByID(self.wishList[i].productID, completeHandler: {(items) in
                        self.wishProductsList.append(items[0])
                        dispatch_async(dispatch_get_main_queue()) {
                            self.RefreshTable()
                        }
                    })
                }
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishProductsList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! WishListViewCell
        let brandItem = wishProductsList[indexPath.row]
        
        cell.name.text = brandItem.getName()
        cell.itemProduct = brandItem
        cell.addToCartButton.tag = indexPath.row
        cell.addToCartButton.addTarget(self, action: "addToCartDialog:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.removeFromWish.tag = indexPath.row
        cell.removeFromWish.addTarget(self, action: "removeFromWishListAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        if let img = imageCache[brandItem.defaultImageName] {
            cell.photo.image = img
        } else {
            let url:NSURL =  NSURL(string: Constant.URL_IMAGE + brandItem.defaultImageName)!
            let session = NSURLSession.sharedSession()
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "GET"
            request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
            
            let task = session.dataTaskWithRequest(request) { (let data, let response, let error) in
                guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                    return
                }
                let image = UIImage(data: data!)
                self.imageCache[brandItem.defaultImageName] = image
                dispatch_async(dispatch_get_main_queue(), {
                    let cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier, forIndexPath: indexPath) as! WishListViewCell
                    cell.photo.image = image
                    tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
                })
            }
            task.resume()
        }
        
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
            OrderController.sharedInstance().getCurrentOrder()?.addProductToCart(self.wishProductsList[actionSheetController.view.tag].ID, completeHandler: {() in
                OrderController.sharedInstance().UpdateUserOrder(UserController.sharedInstance().getUser().ID, completeHandler: {(successInit) in
                    dispatch_async(dispatch_get_main_queue()) {
                        self.removeFromWish(actionSheetController.view.tag)
                        self.RefreshTable()
                        self.tabBarController!.tabBar.items![2].badgeValue = String(OrderController.sharedInstance().getCurrentOrder()!.productItems.count)
                    }
                })
            })
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
    }
    
    func RefreshTable() {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            return
        })
    }
    
}
