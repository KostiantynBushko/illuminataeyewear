//
//  Shipping.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/21/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class Shipment {
    
    var ID = Int64()
    var orderID = Int64()
    var shippingServiceID = Int64()
    var shippingAddressID = Int64()
    var trackingCode = String()
    var dateShipped = String()
    var amount = Float32()
    var taxAmount = Float32()
    var shippingAmount = Float32()
    var status = Int32()
    var shippingServiceData = String()
    
    func GetShipmentByOrerID(orderID: Int64, completeHandler: (Array<Shipment>) -> Void) {
        let url: NSURL = NSURL(string: Constant.URL_BASE_API)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let parameters = "xml=<shipment><list><orderID>" + String(orderID) + "</orderID></list></shipment>"
        request.HTTPBody = parameters.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request, completionHandler: {(let data, let response, let error) in
            guard let _:NSData = data, let _:NSURLResponse = response where error == nil else {
                return
            }
            
            let dataString = (NSString(data: data!, encoding: NSUTF8StringEncoding) as! String).htmlDecoded()
            print("Shipment : " + String(dataString))
            
            XmlShipmentParser().Parse(data!, completeHandler: {(shipmentList) in
                completeHandler(shipmentList)
            })
        })
        task.resume()
    }
    
    func SetShipmentService(orderID: Int64, shippingMethodID: Int64, completeHandler: () -> Void) {
        let url: NSURL = NSURL(string: Constant.URL_BASE_API)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let parameters = "xml=<shipment><set><orderID>" + String(orderID) + "</orderID><shippingServiceID>" + String(shippingMethodID) + "</shippingServiceID></set></shipment>"
        request.HTTPBody = parameters.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request, completionHandler: {(let data, let response, let error) in
            guard let _:NSData = data, let _:NSURLResponse = response where error == nil else {
                return
            }
            
            //let dataString = (NSString(data: data!, encoding: NSUTF8StringEncoding) as! String).htmlDecoded()
            //print("Shipment : " + String(dataString))
            completeHandler()

        })
        task.resume()
    }
}
