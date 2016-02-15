//
//  ItemPageContentViewController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/1/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class ItemPageContentViewController: UIViewController {

    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var property: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    
    var brandItem: BrandItem?
    
    var pageIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = brandItem?.getName()
        price.text = brandItem?.getPrice().definePrices
        
        let url:NSURL =  NSURL(string: Constant.URL_IMAGE + brandItem!.defaultImageName)!
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let task = session.dataTaskWithRequest(request) { (let data, let response, let error) in
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                return
            }
            let image = UIImage(data: data!)
            dispatch_async(dispatch_get_main_queue(), {
                self.photo.image = image
            })
        }
        task.resume()
        
        if(brandItem!.getPrice().definePrices == "") {
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                // do some task
                PriceItem.getPriceBySKU((self.brandItem!.parentBrandItem?.getSKU())!, completeHandler: {(priceItem) in
                    self.brandItem!.setPrice(priceItem)
                    self.brandItem?.parentBrandItem?.setPrice(priceItem)
                    dispatch_async(dispatch_get_main_queue()) {
                        self.price.text = self.brandItem?.getPrice().definePrices
                    }
                })
            }
        }
        ProductVariationValue.GetProductVariationByProductID((brandItem?.ID)!, completeHandler: {(let productVariationValue) in
            ProductVariation.GetProductVariationByID(productVariationValue.getVariationID(), completeHandler: {(let productVariation) in
                dispatch_async(dispatch_get_main_queue()) {
                    self.property.text = productVariation.getName()
                }
            })
        })
        
    }
    
    @IBAction func addProductToCart(sender: AnyObject) {
        self.addToCartDialog()
    }
    
    private func addToCartDialog() {
        let actionSheetController: UIAlertController = UIAlertController(title: "Add to cart", message: "Do you want add this product to your cart", preferredStyle: .Alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in}
        
        actionSheetController.addAction(cancelAction)
        //Create and an option action
        let yesAction: UIAlertAction = UIAlertAction(title: "Yes", style: .Default) { action -> Void in
            OrderController.sharedInstance().getCurrentOrder()?.addProductToCart((self.brandItem?.ID)!, completeHandler: {() in
                OrderController.sharedInstance().UpdateUserOrder(UserController.sharedInstance().getUser()!.ID, completeHandler: {(successInit) in
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tabBarController!.tabBar.items![2].badgeValue = String(OrderController.sharedInstance().getCurrentOrder()!.productItems.count)
                    }
                })
            })
        }
        actionSheetController.addAction(yesAction)
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }

}
