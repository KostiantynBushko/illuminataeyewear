//
//  SerchViewController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 3/3/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class SerchViewController: UITableViewController, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    var categoryID = Int64(-1)
    
    var searchController : UISearchController!
    var brandItems = [BrandItem]()
    let cellIdentifier = "ItemViewCell"
    var isRunning: Bool = false
    
    var imageCache = [String:UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchController = UISearchController(searchResultsController:  nil)
        
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = true
        
        //self.navigationItem.titleView = searchController.searchBar
        
        self.definesPresentationContext = false
        
        self.tableView.tableHeaderView = searchController.searchBar
        
        self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancel:"), animated: true)
        isRunning = true
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidAppear(animated)
        self.searchController = nil
        isRunning = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func cancel(target: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if searchBar.text != nil {
            BrandItem().serchBrandByName(self.categoryID, name: searchBar.text!, start: 0, limit: 50, completeHandler: {(brandItems) in
                if (brandItems.count > 0) {
                    self.brandItems = brandItems
                    self.RefreshTable()
                }
            })
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    }
    
    func RefreshTable() {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            return
        })
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.brandItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier, forIndexPath: indexPath) as! BrandItemViewCell
        let brandItem = brandItems[indexPath.row]
        
        cell.name.text = brandItem.getProductCodeName() //brandItem.getName()
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! BrandItemViewCell
        addProductToCart(cell.BuyNowButton)
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
}
