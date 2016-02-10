//
//  ProductVariationValue.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/9/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation


class ProductVariationValue {
    var ID = Int64()
    var productID = Int64()
    var variationID = Int64()
    
    func setID(ID: Int64) {
        self.ID = ID
    }
    
    func setProductId(productID: Int64) {
        self.productID = productID
    }
    
    func setVariationID(variationID: Int64) {
        self.variationID = variationID
    }
    
    func getUD() -> Int64 {
        return self.ID
    }
    
    func getProductID() -> Int64 {
        return self.productID
    }
    
    func getVariationID() -> Int64 {
        return self.variationID
    }
    
    static func GetProductVariationByProductID(productID: Int64, completeHandler: (ProductVariationValue) -> Void) {
        let url: NSURL = NSURL(string: Constant.URL_BASE_API)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let parameters = "xml=<product_variation_value><list><productID>" + String(productID) + "</productID></list></product_variation_value>"
        request.HTTPBody = parameters.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request, completionHandler: {(let data, let response, let error) in
            guard let _:NSData = data, let _:NSURLResponse = response where error == nil else {
                return
            }
            XmlProductVariationValueParser().Parse(data!, completeHandler: {(productVariationValue) in
                completeHandler(productVariationValue)
            })
        })
        task.resume()
    }
}