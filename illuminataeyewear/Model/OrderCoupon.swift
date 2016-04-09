//
//  OrderCoupon.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 3/27/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class OrderCoupon {
    var ID: Int64?
    var orderID: Int64?
    var discountConditionID	: Int64?
    var couponCode: String?
    
    static func GetOrderCoupons(orderID: Int64, completeHandler: (Array<OrderCoupon>, String?, NSError?) -> Void) {
        let paramString = "xml=<coupon><list><orderID>" + String(orderID) + "</orderID></list></coupon>"
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
            print("Order Coupons : " + dataString)
            XmlOrderCouponParser().Parse(data!, completeHandler: {(coupons, message, error) in
                completeHandler(coupons, message, error)
            })
        }
        task.resume()
    }
    
    static func AddCoupon(orderID: Int64, couponCode: String, completeHandler:(Array<OrderCoupon>, String?, NSError?) -> Void) {
       
        let paramString = "xml=<coupon><add_coupon><orderID>" + String(orderID) + "</orderID><couponCode>" + couponCode + "</couponCode></add_coupon></coupon>"
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
            print("Order Coupons : " + dataString)
            XmlOrderCouponParser().Parse(data!, completeHandler: {(coupons, message, error) in
                completeHandler(coupons, message, error)
            })
        }
        task.resume()
    }
}
