//
//  UserApnToken.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 3/6/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class UserApnToken {
    private var ID: Int64?
    private var userID: Int64?
    private var token: String?
    
    func getID() -> Int64? {
        return nil
    }
    
    func getUserID() -> Int64? {
        return nil
    }
    
    func getToken() -> String? {
        return nil
    }
    
    func setID(ID: Int64) {
        self.ID = ID
    }
    
    func setUserID(userID: Int64) {
        self.userID = userID
    }
    
    func setToken(token: String) {
        self.token = token
    }
    
    static func GetUserApnTokenByUserID(userID: Int64, completeHandler: (UserApnToken) -> Void) {
        let paramString = "xml=<user_apn_token><list><userID>" + String(userID) + "</userID></list></user_apn_token>"
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
            print("UserApnToken : " + dataString)
            XmlUserApnTokenParser().Parse(data!, completeHandler: {(userApnToken) in
                completeHandler(userApnToken)
            })
        }
        task.resume()
    }
    
    static func SaveUserApnToken(userID: Int64?, token: String, completeHandler: () -> Void) {
        var paramString = "xml=<user_apn_token><save>"
        if userID != nil {
            //let id
            paramString.appendContentsOf("<userID>" + String(userID!) + "</userID>")
        }
        paramString.appendContentsOf("<token>" + String(token) + "</token></save></user_apn_token>")
        
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
            DBApnToken.SetSuccessSubmited()
        }
        completeHandler()
        task.resume()
    }
}
