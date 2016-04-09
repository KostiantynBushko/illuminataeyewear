//
//  XmlOrderCouponParser.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 3/26/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class XmlOrderCouponParser: NSObject, NSXMLParserDelegate {
    var TAG_RESPONSE = "response"
    var TAG_COUPON = "coupon"
    
    var element = NSString()
    var xmlParser: NSXMLParser?
    
    var handler: ((Array<OrderCoupon>, String?, NSError?) -> Void)?
    var orderCoupon = OrderCoupon()
    var couponList = [OrderCoupon]()
    var couponCode = String()
    var error: NSError?
    var message: String?
    
    func Parse(data: NSData, completeHandler: (Array<OrderCoupon>, String?, NSError?) -> Void) {
        handler = completeHandler
        xmlParser = NSXMLParser(data: data)
        xmlParser?.delegate = self
        xmlParser?.parse()
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        element = elementName
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if element.isEqualToString("ID") {
            self.orderCoupon.ID = Int64(string)!
        } else if element.isEqualToString("orderID") {
            self.orderCoupon.orderID = Int64(string)!
        } else if element.isEqualToString("discountConditionID") {
            self.orderCoupon.discountConditionID = Int64(string)!
        } else if element.isEqualToString("couponCode") {
            self.couponCode.appendContentsOf(string)
        } else if element.isEqualToString("message") {
            self.message = string
        } else if element.isEqualToString("error") {
            let userInfo: [NSObject : AnyObject] =
            [
                NSLocalizedDescriptionKey :  NSLocalizedString("error", value: string, comment: ""),
                NSLocalizedFailureReasonErrorKey : NSLocalizedString("error", value: string, comment: "")
            ]
            self.error = NSError(domain: "illuminataeyewear.com", code: 401, userInfo: userInfo)
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqualToString(TAG_RESPONSE) {
            handler!(self.couponList, message, error)
        } else if (elementName as NSString).isEqualToString(TAG_COUPON) {
            orderCoupon.couponCode = couponCode
            couponList.append(orderCoupon)
            orderCoupon = OrderCoupon()
            self.couponCode = String()
        }
    }
}
