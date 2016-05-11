//
//  ShippingService.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/20/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class ShippingService {
    
    var ID = Int64()
    var deliveryZoneID = Int64()
    var isFinal = Bool()
    var name = String()
    var position = Int32()
    var rangeType = Int32()
    var description = String()
    var deliveryTimeMinDays = Int32()
    var deliveryTimeMaxDays = Int32()
    
    func GetShippingServices(completeHandler: (Array<ShippingService>, String?, NSError?) -> Void) {
        let url: NSURL = NSURL(string: Constant.URL_BASE_API)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let parameters = "xml=<shipping_service><list></list></shipping_service>"
        request.HTTPBody = parameters.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request, completionHandler: {(let data, let response, let error) in
            guard let _:NSData = data, let _:NSURLResponse = response where error == nil else {
                return
            }
            
            //let dataString = (NSString(data: data!, encoding: NSUTF8StringEncoding) as! String).htmlDecoded()
            //print("ShippingService : " + String(dataString))
            
            XmlShippingServiceParser().Parse(data!, completeHandler: {(shippingList, message, error) in
                completeHandler(shippingList,message, error)
            })
        })
        task.resume()
    }
    
    func GetShippingServiceByID(ID: Int64, completeHandler: (Array<ShippingService>, String?, NSError?) ->Void) {
        let url: NSURL = NSURL(string: Constant.URL_BASE_API)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let parameters = "xml=<shipping_service><list></list></shipping_service>"
        request.HTTPBody = parameters.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request, completionHandler: {(let data, let response, let error) in
            guard let _:NSData = data, let _:NSURLResponse = response where error == nil else {
                return
            }
            
            //let dataString = (NSString(data: data!, encoding: NSUTF8StringEncoding) as! String).htmlDecoded()
            //print("ShippingService : " + String(dataString))
            
            XmlShippingServiceParser().Parse(data!, completeHandler: {(shippingList,message, error) in
                completeHandler(shippingList,message, error)
            })
        })
        task.resume()
    }
    
}
