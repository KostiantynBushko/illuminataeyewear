//
//  ItemPrice.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 1/19/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class PriceItem {
    
    var sku: String = ""
    var definePrices: String = ""
    var defineListPrice: String = ""
    var quantityPrices: String = ""
    
    static func getPriceBySKU(sku: String, completeHandler:(priceItem: PriceItem) -> Void) {
        let url:NSURL = NSURL(string: Constant.URL_BASE_API)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let params = "xml=<price><get>" + sku + "</get></price>"
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) {(let data, let response, let error) in
            guard let _:NSData = data, let _:NSURLResponse = response where error == nil else {
                return
            }
            
            let itemPriceParser = XmlPriceParser()
            itemPriceParser.ParceItem(data!, completeHandler: { (priceItem) in
                completeHandler(priceItem: priceItem)
            })
        }
        task.resume()
    }
}
