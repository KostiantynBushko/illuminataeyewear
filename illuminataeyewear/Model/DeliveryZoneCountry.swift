//
//  DeliveryZoneCountry.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/25/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class DeliveryZoneCountry {
    var ID = Int64()
    var deliveryZoneID = Int64()
    var countryCode = String()
    
    func GetDeliveryZoneCountry(completeHandler: (Array<DeliveryZoneCountry>) -> Void) {
        let url: NSURL = NSURL(string: Constant.URL_BASE_API)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let parameters = "xml=<delivery_zone_country><list></list></delivery_zone_country>"
        request.HTTPBody = parameters.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request, completionHandler: {(let data, let response, let error) in
            guard let _:NSData = data, let _:NSURLResponse = response where error == nil else {
                return
            }
            
            //let dataString = (NSString(data: data!, encoding: NSUTF8StringEncoding) as! String).htmlDecoded()
            //print("DeliveryZoneCountry : " + String(dataString))
            
            XmlDeliveryZoneCountryParser().Parse(data!, completeHandler: {(deliveryZoneCountryList) in
                completeHandler(deliveryZoneCountryList)
            })
        })
        task.resume()
    }
}
