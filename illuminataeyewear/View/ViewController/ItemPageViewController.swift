//
//  ItemPageViewController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/1/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class ItemPageViewController: UIViewController,UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    @IBOutlet weak var content: UIView!
    var parentBrandItem: BrandItem?
    var brandItems = [BrandItem]()
    var currentPage = 0
    
    var pageViewController : UIPageViewController!
    var margin_bottom: Float = 45
    
    func reset() {
        /* Getting the page View controller */
        
        pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        pageViewController.view.backgroundColor = UIColor.whiteColor()
        
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        
        
        let pageContentViewController = self.viewControllerAtIndex(0)
        if pageContentViewController != nil {
            self.pageViewController.setViewControllers([pageContentViewController!], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
            
            /* We are substracting 30 because we have a start again button whose height is 30*/
            self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height - (CGFloat)(self.margin_bottom))
            self.addChildViewController(pageViewController)
            self.view.addSubview(pageViewController.view)
            self.pageViewController.didMoveToParentViewController(self)
        }
    }
    
    var count: Int = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let info: UIBarButtonItem = UIBarButtonItem(image:UIImage(named:"ic_info_outline_18p"), style: .Plain, target:self, action:"productInfo:")
        let wish: UIBarButtonItem = UIBarButtonItem(image:UIImage(named:"wish_black_button"), style: .Plain, target:self, action:"addToWishList:")
        self.navigationItem.setRightBarButtonItems([wish,info], animated: true)
        if self.brandItems.count > 0 && self.parentBrandItem != nil{
            self.title = parentBrandItem?.getProductCodeName()
            reset()
        }
    }
    
    func InitwithProductID(productID: Int64) {
        BrandItem.getBrandItemByID(productID, completeHandler: {(brandItems) in
            if brandItems.count > 0 {
                if brandItems[0].parentID > 0 {
                    self.brandItems.append(brandItems[0])
                    BrandItem.getBrandItemByID(brandItems[0].parentID, completeHandler: {(brandItems) in
                        self.parentBrandItem = brandItems[0]
                        self.brandItems[0].parentBrandItem = self.parentBrandItem
                        dispatch_async(dispatch_get_main_queue()) {
                            self.title = self.parentBrandItem?.getProductCodeName()
                            self.reset()
                        }
                    })
                    
                } else {
                    self.parentBrandItem = brandItems[0]
                    BrandItem.getBrandItemByParentNode(brandItems[0].ID, completeHandler: {(items) in
                        for item in items {
                            item.parentBrandItem = self.parentBrandItem
                        }
                        self.brandItems = items
                        dispatch_async(dispatch_get_main_queue()) {
                            self.title = self.parentBrandItem?.getProductCodeName()
                            self.reset()
                        }
                    })
                }
            }
        })
    }
    
    func addToWishList(sender: AnyObject) {
        addToWishListDialog()
    }
    
    func productInfo(sender: AnyObject) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyBoard.instantiateViewControllerWithIdentifier("ProductInfoNavigationController") as! UINavigationController
        self.presentViewController(navigationController, animated: true, completion: nil)
        let productInfoViewController = navigationController.viewControllers.first as! ProductInfoViewController
        productInfoViewController.brandItem = self.brandItems[currentPage]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ItemPageContentViewController).pageIndex!
        index++
        if(index >= self.brandItems.count){
            return nil
        }
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ItemPageContentViewController).pageIndex!
        if(index <= 0){
            return nil
        }
        index--
        return self.viewControllerAtIndex(index)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return brandItems.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool){
        let pageContentViewController = pageViewController.viewControllers![0] as! ItemPageContentViewController
        currentPage = pageContentViewController.pageIndex!
    }
    
    func viewControllerAtIndex(index : Int) -> UIViewController? {
        //print("View controllr at index " + String(index))
        if((self.brandItems.count == 0) || (index >= self.brandItems.count)) {
            return nil
        }
        let pageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ItemPageContentViewController") as! ItemPageContentViewController
        pageContentViewController.brandItem = brandItems[index]
        pageContentViewController.pageIndex = index
        return pageContentViewController
    }
    
    private func addToWishListDialog() {
        let actionSheetController: UIAlertController = UIAlertController(title: "Add to wish", message: "Do you want add this product to wish list", preferredStyle: .Alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in}
        
        actionSheetController.addAction(cancelAction)
        //Create and an option action
        let yesAction: UIAlertAction = UIAlertAction(title: "Yes", style: .Default) { action -> Void in
            let wishItem = WishItem(productID: self.brandItems[self.currentPage].ID)
            DBWishProductTable.AddItemToWishList(wishItem!)
        }
        actionSheetController.addAction(yesAction)
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }

}
