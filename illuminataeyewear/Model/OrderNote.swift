//
//  OrderNote.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 4/8/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class OrderNote {
    
    var ID = Int64()
    var userID = Int64()
    var orderID = Int64()
    var isRead = Bool()
    var isAdmin = Bool()
    var time = String()
    var text = String()

    func GetOrderNote(orderID: Int64, completeHandler: (Array<OrderNote>, String?, NSError?) -> Void) {
        let paramString = "xml=<order_note><list><orderID>" + String(orderID) + "</orderID></list></order_note>"
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
            print("Order notes : " + dataString)
            
            XmlOrderNoteParser().Parse(data!, completeHandler: {(notes, message, error)in
                completeHandler(notes, message, error)
            })
        }
        task.resume()
    }
    
    func SendMessage(orderID: Int64, message: String, completeHandler: (Array<OrderNote>, String?, NSError?) -> Void) {
        let paramString = "xml=<order_note><send><orderID>" + String(orderID) + "</orderID><text>" + message + "</text></send></order_note>"
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
            print("Order notes : " + dataString)
            
            XmlOrderNoteParser().Parse(data!, completeHandler: {(notes, message, error)in
                completeHandler(notes, message, error)
            })
        }
        task.resume()
    }
}