//
//  ItemPageViewController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/1/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class ItemPageViewController: UIPageViewController,UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    @IBOutlet weak var content: UIView!
    var parentBrandItem: BrandItem?
    var brandItems = [BrandItem]()
    
    var pageViewController : UIPageViewController!
    
    func reset() {
        /* Getting the page View controller */
        
        pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        pageViewController.view.backgroundColor = UIColor.whiteColor()
        
        self.pageViewController.dataSource = self
        
        
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
        
        /*dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            // do your task
            BrandItem.getBrandItemByParentNode((self.parentBrandItem?.ID)!, completeHandler: {(brandItems) in
                for item in brandItems {
                    if item.parentID > 0 {
                        self.count += 1
                    }
                }
                
                for item in brandItems {
                    item.parentBrandItem = self.parentBrandItem!
                    self.brandItems.append(item)
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.reset()
                    return
                })
            })
        }*/
        
        reset()
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

    
    func viewControllerAtIndex(index : Int) -> UIViewController? {
        if((self.brandItems.count == 0) || (index >= self.brandItems.count)) {
            return nil
        }
        let pageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ItemPageContentViewController") as! ItemPageContentViewController
        pageContentViewController.brandItem = brandItems[index]
        pageContentViewController.pageIndex = index
        return pageContentViewController
    }

}
