//
//  SpecificationStringValue.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 4/14/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class SpecificationStringValue: BaseModel{

    var productID = Int64()
    var specFieldID = Int64()
    var value = String()
    
    
    func GetSpecifucationStringValueList(productID: Int64, completeHandler: (Array<SpecificationStringValue>, String?, NSError?) -> Void) {
        let paramString = "xml=<specification_string_value><list><productID>" + String(productID) + "</productID></list></specification_string_value>"
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
            //print("SpecificationStringValue : " + dataString)
            
            XmlSpecificationStringValueParser().Parse(data!, completeHandler: {(stringValues, message, error)in
                completeHandler(stringValues, message, error)
            })
        }
        task.resume()
    }
}
