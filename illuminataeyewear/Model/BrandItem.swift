//
//  BrandItem.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 1/13/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class BrandItem {
    
    // MARK: Properties
    
    var ID = Int()
    var categoryID = String()
    var manufacturerID = String()
    var defaultImageID = String()
    var parentID = String()
    var shippingClassID = String()
    var taxClassID = String()
    var isEnabled = String()
    var sku = String()
    var name = String()
    var shortDescription = String()
    var longDescription = String()
    var keywords = String()
    var pageTitle = String()
    var dateCreated = String()
    var dateUpdated = String()
    var URL = String()
    var isFeatured = String()
    var type = String()
    var ratingSum = String()
    var ratingCount = String()
    var rating = String()
    var reviewCount = String()
    var minimumQuantity = String()
    var shippingSurchargeAmount = String()
    var isSeparateShipment = String()
    var isFreeShipping = String()
    var isBackOrderable = String()
    var isFractionalUnit = String()
    var isUnlimitedStock = String()
    var shippingWeight = String()
    var stockCount = String()
    var reservedCount = String()
    var salesRank = String()
    var fractionalStep = String()
    var position = String()
    var categoryIntervalCache = String()
    var custom = String()
    var ProductDefaultImage_title = String()
    var ProductDefaultImage_URL = String()
    var Manufacturer_name = String()
    var Category_name = String()
    
    
    var image: UIImage?
    var defaultImageName: String!
    
    var priceItem = PriceItem()
    
    static func getBrandItems(categoryID: String, completeHandler: (Array<BrandItem>) -> Void){
        let paramString = "xml=<product><list limit=50><categoryID>" + (categoryID) + "</categoryID></list></product>"
        let url: NSURL = NSURL(string: Constant.URL_BASE_API)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL:url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
    
        let task = session.dataTaskWithRequest(request){ (let data, let response, let error) in
            guard let _:NSData = data, let _:NSURLResponse = response where error == nil else {
                return
            }
            XmlBrandParser().ParseItems(data!, completeHandler: {(brandItems) in
                completeHandler(brandItems)
            })
        }
        task.resume()
    }
    
    static func getBrandItemByID(ID: String, completeHandler: (Array<BrandItem>) -> Void){
        let paramString = "xml=<product><list><ID>" + ID + "</ID></list></product>"
        let url: NSURL = NSURL(string: Constant.URL_BASE_API)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL:url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request){ (let data, let response, let error) in
            guard let _:NSData = data, let _:NSURLResponse = response where error == nil else {
                return
            }
            XmlBrandParser().ParseItems(data!, completeHandler: {(brandItems) in
                completeHandler(brandItems)
            })
        }
        task.resume()
    }
}
