//
//  OrderedItemOption.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 4/1/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class OrderedItemOption: NSObject {

    var orderedItemID = Int64()
    var choiceID = Int64()
    var priceDiff: Float64 = 0.0
    var optionText = String()

    func GetOrderedItemOption(orderedItemID: Int64, completeHandler: (Array<OrderedItemOption>, String?, NSError?) -> Void) {
        let paramString = "xml=<ordered_item_option><list><orderedItemID>" + String(orderedItemID) + "</orderedItemID></list></ordered_item_option>"
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
            //print("Ordered Item option : " + dataString)
            
            XmlOrderedItemOptionParser().Parse(data!, completeHandler: {(options, message, error)in
                completeHandler(options, message, error)
            })
        }
        task.resume()
    }
    
    func SetOrderedItemOption(orderedItemID: Int64, productOptionChoice: Int64, optionText: String?, completeHandler: (Array<OrderedItemOption>, String?, NSError?) -> Void) {
        
        var paramString = "xml=<ordered_item_option><set><orderedItemID>" + String(orderedItemID) + "</orderedItemID><choiceID>" + String(productOptionChoice) + "</choiceID>"
        if optionText != nil {
            paramString.appendContentsOf("<optionText>")
            paramString.appendContentsOf(optionText!)
            paramString.appendContentsOf("</optionText>")
            paramString.appendContentsOf("</set></ordered_item_option>")
        } else {
            paramString.appendContentsOf("</set></ordered_item_option>")
        }
        //</set></ordered_item_option>"
        
        
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
            //print("Ordered Item option : " + dataString)
            
            XmlOrderedItemOptionParser().Parse(data!, completeHandler: {(options, message, error)in
                completeHandler(options, message, error)
            })
        }
        task.resume()
    }
}
