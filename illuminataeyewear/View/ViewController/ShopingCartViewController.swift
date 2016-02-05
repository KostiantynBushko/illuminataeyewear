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
    
    var isRunning: Bool = false
    var brandItems = [BrandItem]()
    var orderProductItems = [OrderProductItem]()
    var imageCache = [String:UIImage]()
    
    let cellIdentifier = "OrderViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        isRunning = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let order = OrderController.sharedInstance().getCurrentOrder()
        
        if order?.productItems.count > orderProductItems.count {
            orderProductItems = [OrderProductItem]()
            brandItems = [BrandItem]()
            self.RefreshTable();
            if order?.productItems.count > 0 {
                orderProductItems = (order?.productItems)!
                for itemProduct in (order?.productItems)! {
                    BrandItem.getBrandItemByID(itemProduct.productID, completeHandler: {(items) in
                        if items.count > 0 {
                            if items[0].parentID > 0 {
                                items[0].initParentNodeBrandItem({(brandItem) in
                                    self.brandItems.append(items[0])
                                    self.RefreshTable()
                                })
                            } else {
                                self.brandItems.append(items[0])
                                self.RefreshTable()
                            }
                        }
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
        
        cell.name.text = brandItems[indexPath.row].getName()
        cell.price.text = brandItems[indexPath.row].getPrice().definePrices
        cell.quantity.text = String(orderProductItems[indexPath.row].count)
        
        if(brandItem.getPrice().definePrices == "") {
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                // do some task
                PriceItem.getPriceBySKU((brandItem.getSKU()), completeHandler: {(priceItem) in
                    self.brandItems[indexPath.row].setPrice(priceItem)
                    dispatch_async(dispatch_get_main_queue()) {
                        if self.isRunning {
                            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
                        }
                    }
                })
            }
        } else {
            let cost = Float32(brandItems[indexPath.row].getPrice().definePrices)! * Float32(orderProductItems[indexPath.row].count)
            cell.cost.text = String(cost)
        }
        
        // Product photo
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
                    let cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier, forIndexPath: indexPath) as! OrderViewCell
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
