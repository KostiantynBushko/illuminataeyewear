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
    
    //var shippingAddress
    
    static func UserLogIn(email: String, password: String, completeHandler: (user: User?, error: NSError?) -> Void) {
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
            //let dataString = (NSString(data: data!, encoding: NSUTF8StringEncoding) as! String).htmlDecoded()
            //print(dataString)
            XmlUserParser().ParseUser(data!, completeHandler: {(user, error) in
                completeHandler(user: user, error: error)
            })
        }
        task.resume()
    }
    
    static func EmailAlreadyExist(email: String, completeHandler: (Bool, NSError?) -> Void) {
        let paramString = "xml=<customer><email_exist><email>" + email + "</email></email_exist></customer>"
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
            XmlSimpleStateParser().Parse(data!, completeHandler: {(exist, error) in
                completeHandler(exist, error)
            })
        }
        task.resume()
    }
    
    static func UserRegistered(email: String, pass: String, firstName: String, lastName: String, company: String, completeHandler: (Bool, NSError?) -> Void) {
        let paramString = "xml=<customer><do_register><firstName>" + firstName + "</firstName><lastName>" + lastName + "</lastName><email>" + email + "</email><password>" + pass + "</password><companyName>" + company + "</companyName></do_register></customer>"
        
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
            XmlSimpleStateParser().Parse(data!, completeHandler: {(exist, error) in
                completeHandler(exist, error)
            })
        }
        task.resume()
    }
    
}
