//
//  StaticPage.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 4/8/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class StaticPage {

    var ID = Int64()
    var parentID = Int64()
    var handle = String()
    var title = String()
    var text = String()
    var metaDescription = String()
    var menu = Int64()
    var position = Int64()
    
    func GetStaticPage(ID: Int64, completeHandler: (Array<StaticPage>, String?, NSError?) -> Void) {
        let paramString = "xml=<static_page><list><ID>" + String(ID) + "</ID></list></static_page>"
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
            //print("Static Page : " + dataString)
            
            XmlStaticPageParser().Parse(data!, completeHandler: {(pages, message, error)in
                completeHandler(pages, message, error)
            })
        }
        task.resume()
    }
}
