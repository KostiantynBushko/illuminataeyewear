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
        wishList = DBWishProductTable.SelectWish()
    }
    
    override func viewDidAppear(animated: Bool) {
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
    
    func RefreshTable() {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            return
        })
    }
    
}
