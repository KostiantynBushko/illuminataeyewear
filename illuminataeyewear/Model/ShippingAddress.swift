//
//  ShippingAddress.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/17/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class ShippingAddress: BaseModel {
    
    var ID = Int64()
    var userID = Int64()
    var userAddressID = Int64()
    
    
    func GetShippingAddress(ID: Int64?, completeHandler: (Array<ShippingAddress>, String?, NSError?) -> Void) {
        let url: NSURL = NSURL(string: Constant.URL_BASE_API)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        var parameters = "xml=<shipping_address><list>"
        if ID != nil {
            parameters.appendContentsOf("<ID>")
            parameters.appendContentsOf(String(ID))
            parameters.appendContentsOf("</ID>")
        }
        parameters.appendContentsOf("</list></shipping_address>")
        
        request.HTTPBody = parameters.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request, completionHandler: {(let data, let response, let error) in
            guard let _:NSData = data, let _:NSURLResponse = response where error == nil else {
                return
            }
            
            //let dataString = (NSString(data: data!, encoding: NSUTF8StringEncoding) as! String).htmlDecoded()
            //print("ShippingAddress : " + String(dataString))
            
            XmlShippingAddressParser().Parse(data!, completeHandler: {(addresses, message, error) in
                if error != nil {
                    self.CreateShippingAddress((UserController.sharedInstance().getUser()?.ID)!, completeHandler: {(addresses, message, error) in
                        completeHandler(addresses, message, error)
                    })
                } else {
                    completeHandler(addresses, message, error)
                }
            })
        })
        task.resume()
    }
    
    func CreateShippingAddress(userID: Int64, completeHandler: (Array<ShippingAddress>, String?, NSError?) -> Void) {
        let url: NSURL = NSURL(string: Constant.URL_BASE_API)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let parameters = "xml=<shipping_address><create><userID>" + String(userID) + "</userID></create></shipping_address>"
        request.HTTPBody = parameters.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request, completionHandler: {(let data, let response, let error) in
            guard let _:NSData = data, let _:NSURLResponse = response where error == nil else {
                return
            }
            
            let dataString = (NSString(data: data!, encoding: NSUTF8StringEncoding) as! String).htmlDecoded()
            print("Create Shipping Address : " + String(dataString))
            
            XmlShippingAddressParser().Parse(data!, completeHandler: {(addresses, message, error) in
                completeHandler(addresses, message, error)
            })
        })
        task.resume()
    }
}