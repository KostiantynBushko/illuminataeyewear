//
//  DeliveryZone.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/25/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class DeliveryZone {
    
    var ID = Int64()
    var name = String()
    var isEnabled = Bool()
    var isFreeShipping = Bool()
    var isRealTimeDisabled = Bool()
    var type = Int32()
    
    func GetDeliveryZone(completeHandler: (Array<DeliveryZone>) -> Void) {
        let url: NSURL = NSURL(string: Constant.URL_BASE_API)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let parameters = "xml=<delivery_zone><list></list></delivery_zone>"
        request.HTTPBody = parameters.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request, completionHandler: {(let data, let response, let error) in
            guard let _:NSData = data, let _:NSURLResponse = response where error == nil else {
                return
            }
            
            //let dataString = (NSString(data: data!, encoding: NSUTF8StringEncoding) as! String).htmlDecoded()
            //print("DeliveryZone : " + String(dataString))
            
            XmlDeliveryZoneParser().Parse(data!, completeHandler: {(deliveryZoneList) in
                completeHandler(deliveryZoneList)
            })
        })
        task.resume()
    }
}
