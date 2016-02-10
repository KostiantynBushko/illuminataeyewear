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
    
    var ID = Int64()
    var categoryID = String()
    var manufacturerID = String()
    var defaultImageID = String()
    var parentID = Int64()
    var shippingClassID = String()
    var taxClassID = String()
    var isEnabled = String()
    private var sku = String()
    private var name = String()
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
    
    var parentBrandItem: BrandItem?
    private var priceItem = PriceItem()
    
    var parentNodeInitHandler: ((brandItem: BrandItem) -> Void)!
    
    func initParentNodeBrandItem(completeHandler: (brandItem: BrandItem) -> Void) {
        if parentID > 0 {
            parentNodeInitHandler = completeHandler
            BrandItem.getBrandItemByID(self.parentID, completeHandler: {(items) in
                self.parentBrandItem = items[0]
                self.parentNodeInitHandler(brandItem: self.parentBrandItem!)
            })
        }
    }
    
    func getDefaultImage(completeHandker:(success: Bool) -> Void) {
        let url:NSURL =  NSURL(string: Constant.URL_IMAGE + self.defaultImageName)!
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let task = session.dataTaskWithRequest(request) { (let data, let response, let error) in
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                completeHandker(success: false)
                return
            }
            self.image = UIImage(data: data!)
            completeHandker(success: true)
        }
        task.resume()
    }
    
    // Geters
    func getName() -> String {
        if !(parentBrandItem == nil) {
            if name.isEmpty && !parentBrandItem!.getName().isEmpty{
                name = parentBrandItem!.getName()
            }
        }
        return name
    }
    func getSKU() -> String {
        if (parentBrandItem != nil) {
            self.sku = parentBrandItem!.getSKU()
        }
        return self.sku
    }
    
    func getPrice() -> PriceItem {
        if (parentBrandItem != nil) {
            self.priceItem = parentBrandItem!.getPrice()
        }
        return self.priceItem
    }
    
    // Setter
    func setName(name: String) {
        self.name = name.htmlDecoded()
    }
    
    func setSKU(sku: String) {
        self.sku = sku.htmlDecoded()
    }
    
    func setPrice(priceItem: PriceItem) {
        parentBrandItem?.setPrice(priceItem)
        self.priceItem = priceItem
    }
    
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
    
    static func getBrandItemByParentNode(parentID: Int64, completeHandler: (Array<BrandItem>) -> Void) {
        let paramString = "xml=<product><list><parentID>" +  String(parentID) + "</parentID></list></product>"
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
    
    static func getBrandItemByID(ID: Int64, completeHandler: (Array<BrandItem>) -> Void){
        let paramString = "xml=<product><list><ID>" + String(ID) + "</ID></list></product>"
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
