//
//  BillingAddress.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/17/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class BillingAddress: BaseModel {
    var ID = Int32()
    var userID = Int32()
    var userAddressID = Int32()
    
    
    func GetBillingAddressByID(ID: Int32, completeHandler: (Array<BillingAddress>) -> Void) {
        let url: NSURL = NSURL(string: Constant.URL_BASE_API)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let parameters = "xml=<billing_address><list><ID>" + String(ID) + "</ID></list></billing_address>"
        request.HTTPBody = parameters.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request, completionHandler: {(let data, let response, let error) in
            guard let _:NSData = data, let _:NSURLResponse = response where error == nil else {
                return
            }
            
            //let dataString = (NSString(data: data!, encoding: NSUTF8StringEncoding) as! String).htmlDecoded()
            //print("BillingAddress : " + String(dataString))
            
            XmlBillingAddressParser().Parse(data!, completeHandler: {(addresses) in
                completeHandler(addresses)
            })
        })
        task.resume()
    }
}
