//
//  NewsPost.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 1/23/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation


class NewsPost {
    
    var ID = Int()
    var isEnabled = Bool()
    var position = Int()
    var time = String()
    var title = String()
    var text = String()
    var moreText = String()
    var img = String()
    
 
    static func getNewsPost(completeHandler: (Array<NewsPost>) -> Void) {
        let paramString = "xml=<newspost><list></list></newspost>"
        let url: NSURL = NSURL(string: Constant.URL_BASE_API)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL:url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request){ (let data, let response, let error) in
            guard let _:NSData = data, let _:NSURLResponse = response where error == nil else {
                return
            }
            XmlNewsPosParser().ParseItems(data!, completeHandler: {(newsPostItems) in
                completeHandler(newsPostItems)
            })
        }
        task.resume()
    }
}
