//
//  ShippingRate.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/26/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class ShippingRate {
    
    var ID = Int64()
    var shippingServiceID = Int64()
    var weightRangeStart = Float32()
    var weightRangeEnd = Float32()
    var subtotalRangeStart = Float32()
    var subtotalRangeEnd = Float32()
    var flatCharge = Float32()
    var perItemCharge = Float32()
    var subtotalPercentCharge = Float32()
    var perKgCharge = Float32()
    
    /*func GetShippingRate(params: String?,completeHandler: (Array<ShippingRate>) -> Void) {
        let url: NSURL = NSURL(string: Constant.URL_BASE_API)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        var parameters = "xml=<shipping_rate><list>"
        if params != nil {
            parameters += String(params)
        }
        parameters += "</list></shipping_rate>"
        
        request.HTTPBody = parameters.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request, completionHandler: {(let data, let response, let error) in
            guard let _:NSData = data, let _:NSURLResponse = response where error == nil else {
                return
            }
            
            let dataString = (NSString(data: data!, encoding: NSUTF8StringEncoding) as! String).htmlDecoded()
            print("DeliveryZoneCountry : " + String(dataString))
            
            XmlShippingRateParser().Parser(data!, completeHandler: {(shippingRateList) in
                completeHandler(shippingRateList)
            })
        })
        task.resume()
    }*/
    
    func GetShippingRateByServiceID(serviceID: Int64,completeHandler: (Array<ShippingRate>) -> Void) {
        let url: NSURL = NSURL(string: Constant.URL_BASE_API)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let parameters = "xml=<shipping_rate><list><shippingServiceID>" + String(serviceID) + "</shippingServiceID></list></shipping_rate>"
        
        request.HTTPBody = parameters.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request, completionHandler: {(let data, let response, let error) in
            guard let _:NSData = data, let _:NSURLResponse = response where error == nil else {
                return
            }
            
            //let dataString = (NSString(data: data!, encoding: NSUTF8StringEncoding) as! String).htmlDecoded()
            //print("DeliveryZoneCountry : " + String(dataString))
            
            XmlShippingRateParser().Parser(data!, completeHandler: {(shippingRateList) in
                completeHandler(shippingRateList)
            })
        })
        task.resume()
    }
}