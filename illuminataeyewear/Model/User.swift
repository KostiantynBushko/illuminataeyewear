//
//  User.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/2/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class User {
    var ID = Int64()
    var defaultShippingAddressID = Int64()
    var defaultBillingAddressID = Int64()
    var userGroupID = Int64()
    var eavObjectID = Int64()
    var locale = String()
    var email = String()
    var firstName = String()
    var lastName = String()
    var companyName = String()
    var dateCreated = String()
    var isEnabled = Bool()
    
    
    static func UserLogIn(email: String, password: String, completeHandler: (user: User?) -> Void) {
        let paramString = "xml=<customer><do_login><email>" + email + "</email><password>" + password + "</password></do_login></customer>"
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
            let dataString = (NSString(data: data!, encoding: NSUTF8StringEncoding) as! String).htmlDecoded()
            print(dataString)
            XmlUserParser().ParseUser(data!, completeHandler: {(user) in
                completeHandler(user: user)
            })
        }
        task.resume()
    }
}
