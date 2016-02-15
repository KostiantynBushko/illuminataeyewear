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
            self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height - 45)
            self.addChildViewController(pageViewController)
            self.view.addSubview(pageViewController.view)
            self.pageViewController.didMoveToParentViewController(self)
        }
    }
    
    var count: Int = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = parentBrandItem?.getName()
        self.navigationItem.setRightBarButtonItem((UIBarButtonItem(image:UIImage(named:"wish_black_button"), style: .Plain, target:self, action:"addToWishList:")), animated: false)
        reset()
    }
    
    func addToWishList(sender: AnyObject) {
        print(currentPage)
        addToWishListDialog()
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
        print(currentPage)
        
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
