//
//  ProductOption.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 3/30/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class ProductOption {
    
    var ID = Int64()
    var productID = Int64()
    var categoryID: Int64?
    var defaultChoiceID: Int64?
    var name = String()
    var description = String()
    var selectMessage = String()
    var type = Int64()
    var displayType = Int64()
    var isRequired = Bool()
    var isDisplayed = Bool()
    var isDisplayedInList = Bool()
    var isDisplayedInCart = Bool()
    var isPriceIncluded = Bool()
    var position = Int()
    
    func GetProductOption(productID: Int64, completeHandler: (Array<ProductOption>, String?, NSError?) -> Void) {
        let paramString = "xml=<product_option><filter><productID>" + String(productID) + "</productID></filter></product_option>"
        let url = NSURL(string: Constant.URL_BASE_API)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request){ (let data, let response, let error) in
            guard let _:NSData = data, let _:NSURLResponse = response where error == nil else {
                return
            }
            //let dataString = (NSString(data: data!, encoding: NSUTF8StringEncoding) as! String).htmlDecoded()
            //print("Product Options : " + dataString)
            
            XmlProductOptionParser().Parse(data!, completeHandler: {(options, message, error)in
                completeHandler(options, message, error)
            })
        }
        task.resume()
    }
    
}