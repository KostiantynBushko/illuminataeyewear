//
//  ProductOptionChoice.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 4/1/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class ProductOptionChoice {
    
    var ID = Int64()
    var optionID = Int64()
    var priceDiff: Float64?
    var hasImage = Bool()
    var position = Int()
    var name = String()
    
    
    func GetProductOptionChoice(optionID: Int64, completeHandler: (Array<ProductOptionChoice>, String?, NSError?) -> Void) {
        let paramString = "xml=<product_option_choice><filter><optionID>" + String(optionID) + "</optionID></filter></product_option_choice>"
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
            //print("Product Options Choice: " + dataString)
            
            XmlProductOptionChoiceParser().Parse(data!, completeHandler: {(options, message, error)in
                completeHandler(options, message, error)
            })
        }
        task.resume()
    }
}
