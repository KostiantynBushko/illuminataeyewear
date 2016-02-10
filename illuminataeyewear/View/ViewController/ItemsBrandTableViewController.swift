//
//  ItemsBrandTableViewController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 1/13/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit
import Foundation

class ItemsBrandTableViewController: UITableViewController, NSXMLParserDelegate {
    
    var isRunning: Bool = false
    var brand: Brand?
    var brandItems = [BrandItem]()
    var imageCache = [String:UIImage]()
    
    let cellIdentifier = "BrandItemViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isRunning = true
        super.title = brand?.brandName
        getProduct()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(false)
        isRunning = false
    }
    
    
    // MARK: Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return brandItems.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! BrandItemViewCell
        
        let brandItem = brandItems[indexPath.row]
        
        cell.name.text = brandItem.getName()
        cell.number.text = String(indexPath.row)
        cell.price.text = "CAD $ " + brandItem.getPrice().definePrices
        cell.brandItem = brandItem
        (cell.BuyNowButton as ExButton).id = indexPath.row
        
        if(brandItem.getPrice().definePrices == "") {
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                // do some task
                PriceItem.getPriceBySKU((brandItem.getSKU()), completeHandler: {(priceItem) in
                    self.brandItems[indexPath.row].setPrice(priceItem)
                    dispatch_async(dispatch_get_main_queue()) {
                        // update some UI
                        if self.isRunning {
                            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
                        }
                    }
                })
            }
        }
        
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
                    let cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier, forIndexPath: indexPath) as! BrandItemViewCell
                    cell.photo.image = image
                    tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
                })
            }
            task.resume()
        }
        
        
        return cell
    }
    
    @IBAction func addProductToCart(sender: AnyObject) {
        let index = (sender as! ExButton).id
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            BrandItem.getBrandItemByParentNode(self.brandItems[index].ID, completeHandler: {(brandItems) in
                for item in brandItems {
                    item.parentBrandItem = self.brandItems[index]
                    //self.brandItems.append(item)
                }
                dispatch_async(dispatch_get_main_queue(), {
                    let index = (sender as! ExButton).id
                    let itemPageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ItemPageViewController") as? ItemPageViewController
                    self.navigationController?.pushViewController(itemPageViewController!, animated: true)
                    itemPageViewController!.brandItems = brandItems
                    itemPageViewController!.parentBrandItem = self.brandItems[index]
                    return
                })
            })
        }
    }
    
    /***********************************************************************************************************/
     // Make http request to get brand list
     /***********************************************************************************************************/
    func getProduct() {
        BrandItem.getBrandItems((brand?.categoryId)!, completeHandler: {(brandItems) in
            self.brandItems = brandItems
            self.RefreshTable()
        })
    }
    
    func RefreshTable() {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            return
        })
    }
}







































