//
//  Order.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 1/29/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class Order {
    var ID = Int64()
    var userID = Int64()
    var shippingAddressID = Int64()
    var billingAddressID = Int64()
    var currencyID = String()
    var eavObjectID = Int64()
    var invoiceNumber = Int64()
    var checkoutStep = Int()
    var dateCreated = String()
    var dateCompleted = String()
    var totalAmount = Int()
    var capturedAmount = Int()
    var isMultiAddress: Bool = false
    var isFinalized: Bool = false
    var isPaid: Bool = false
    var isCancelled: Bool = false
    var status = Int()
    
    var User_userGroupID = Int()
    var User_email = String()
    var User_firstName = String()
    var User_lastName = String()
    var User_companyName = String()
    var User_isEnabled = Int()
    
    var ShippingAddress_stateID = Int64()
    var ShippingAddress_phone = String()
    var ShippingAddress_firstName = String()
    var ShippingAddress_lastName = String()
    var ShippingAddress_companyName = String()
    var ShippingAddress_address1 = String()
    var ShippingAddress_address2 = String()
    var ShippingAddress_city = String()
    var ShippingAddress_stateName = String()
    var ShippingAddress_postalCode = String()
    var ShippingAddress_countryID = String()
    var ShippingAddress_countryName = String()
    var ShippingAddress_fullName = String()
    var ShippingAddress_compact = String()
    
    var BillingAddress_stateID = Int64()
    var BillingAddress_phone = String()
    var BillingAddress_firstName = String()
    var BillingAddress_lastName = String()
    var BillingAddress_companyName = String()
    var BillingAddress_address1 = String()
    var BillingAddress_address2 = String()
    var BillingAddress_city = String()
    var BillingAddress_stateName = String()
    var BillingAddress_postalCode = String()
    var BillingAddress_countryID = String()
    var BillingAddress_countryName = String()
    var BillingAddress_fullName = String()
    var BillingAddress_compact = String()
    
    var productItems = [OrderProductItem]()
    
    static func getOrder(userID: Int64, completeHandler: (ordersList: Array<Order>) -> Void) {
        let paramString = "xml=<order><user_cart><userID>" + String(userID) + "</userID></user_cart></order>"
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
            XmlOrderParser().ParseOrder(data!, completeHandler: {(ordersList) in
                completeHandler(ordersList: ordersList)
            })
        }
        task.resume()
    }
    
}

class OrderProductItem {
    var sku = String()
    var name = String()
    var customerOrderID = Int64()
    var shipmentID = Int64()
    var price = String()
    var count = Int()
    var reservedProductCount = Int()
    var dateAdded = String()
    var isSavedForLater = Bool()
}













