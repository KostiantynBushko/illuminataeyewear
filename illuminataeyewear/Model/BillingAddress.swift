//
//  BillingAddress.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/17/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class BillingAddress: BaseModel {
    var ID = Int64()
    var userID = Int64()
    var userAddressID = Int64()
    
    
    func GetBillingAddress(ID: Int32?, completeHandler: (Array<BillingAddress>, String?, NSError?) -> Void) {
        let url: NSURL = NSURL(string: Constant.URL_BASE_API)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        var parameters = "xml=<billing_address><list>"
        if ID != nil {
            parameters.appendContentsOf("<ID>")
            parameters.appendContentsOf(String(ID))
            parameters.appendContentsOf("</ID>")
        }
        parameters.appendContentsOf("</list></billing_address>")
        
        request.HTTPBody = parameters.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request, completionHandler: {(let data, let response, let error) in
            guard let _:NSData = data, let _:NSURLResponse = response where error == nil else {
                return
            }
            
            //let dataString = (NSString(data: data!, encoding: NSUTF8StringEncoding) as! String).htmlDecoded()
            //print("BillingAddress : " + String(dataString))
            
            XmlBillingAddressParser().Parse(data!, completeHandler: {(addresses, message, error) in
                if error != nil {
                    self.CreateBillingAddress((UserController.sharedInstance().getUser()?.ID)!, completeHandler: {(addresses, message, error) in
                        completeHandler(addresses, message, error)
                    })
                } else {
                    completeHandler(addresses, message, error)
                }
            })
        })
        task.resume()
    }
    
    func CreateBillingAddress(userID: Int64, completeHandler: (Array<BillingAddress>, String?, NSError?) -> Void) {
        let url: NSURL = NSURL(string: Constant.URL_BASE_API)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let parameters = "xml=<billing_address><create><userID>" + String(userID) + "</userID></create></billing_address>"
        request.HTTPBody = parameters.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request, completionHandler: {(let data, let response, let error) in
            guard let _:NSData = data, let _:NSURLResponse = response where error == nil else {
                return
            }
            
            //let dataString = (NSString(data: data!, encoding: NSUTF8StringEncoding) as! String).htmlDecoded()
            //print("Create Billing Address : " + String(dataString))
            
            XmlBillingAddressParser().Parse(data!, completeHandler: {(addresses, message, error) in
                completeHandler(addresses, message, error)
            })
        })
        task.resume()
    }
}
