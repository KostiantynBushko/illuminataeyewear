//
//  Banner.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 4/22/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class Banner {
    var ID = Int64()
    var order = Int64()
    var file = String()
    
    func GetBanners(completeHandler: (Array<Banner>, String?, NSError?) -> Void) {
        let paramString = "xml=<banner><list></list></banner>"
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
           // let dataString = (NSString(data: data!, encoding: NSUTF8StringEncoding) as! String).htmlDecoded()
            //print("SpecificationStringValue : " + dataString)
            
            XmlBannerParser().Parse(data!, completeHandler: {(banners, message, error)in
                completeHandler(banners, message, error)
            })
        }
        task.resume()
    }
}
