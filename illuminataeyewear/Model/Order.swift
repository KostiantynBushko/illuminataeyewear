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
    private var currencyID = String()
    var eavObjectID = Int64()
    var invoiceNumber = String()
    var checkoutStep = Int()
    var dateCreated = String()
    var dateCompleted = String()
    var totalAmount = Float32()
    var capturedAmount = Float32()
    var isMultiAddress: Bool = false
    var isFinalized: Bool = false
    var isPaid: Bool = false
    var isCancelled: Bool = false
    var status = Int(-1)
    
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
    
    var userShippingAddress = UserAddress()
    var userBillingAddress = UserAddress()

    static func GetOrderByID(ID: Int64, completeHandler: (Order) -> Void) {
        let paramString = "xml=<order><list><ID>" + String(ID) + "</ID><isFinalized>0</isFinalized></list></order>"
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
            //print("GetOrderByID : " + dataString)
            XmlOrderParser().ParseOrder(data!, completeHandler: {(ordersList) in
                if ordersList != nil && ordersList?.count > 0 {
                    ordersList![0].InitUserAddress()
                    ordersList![0].InitOrderedItemOption({()in})
                    completeHandler(ordersList![0])
                }
            })
        }
        task.resume()
    }
    
    func InitUserAddress() {
        UserAddress().GetAddressByID(self.shippingAddressID, completeHandler: {(userAddress) in
            self.userShippingAddress = userAddress
        })
        UserAddress().GetAddressByID(self.billingAddressID, completeHandler: {(userAddress) in
            self.userBillingAddress = userAddress
        })
    }
    
    func InitOrderedItemOption(completeHandler: () -> Void) {
        for productItem in self.productItems {
            productItem.InitOrderedItemOption({(options)in})
        }
    }
    
    func addProductToCart(productId: Int64, completeHandler: (Array<OrderProductItem>, String?, NSError?) -> Void) {
        let paramString = "xml=<ordered_item><add_to_cart><customerOrderID>"
            + String(ID) + "</customerOrderID><productID>"
            + String(productId) + "</productID><count>1</count></add_to_cart></ordered_item>"
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
            //print("AddProductToCart : " + String(dataString))
            XmlOrderedItemParser().Parse(data!, completeHandler: {(orderedItem, message, error) in
                completeHandler(orderedItem, message, error)
            })
        }
        task.resume()
    }
    
    func GetTaxAmount(ID: Int64, completeHandler: (Float32, String?, NSError?) -> Void) {
        let paramString = "xml=<order><get_tax><ID>" + String(ID) + "</ID></get_tax></order>"
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
            //print("Order " + String(ID) + " taxAmoun : " + String(dataString))
            XmlFloatValueParser().Parse(data!, completeHandler: {(value, message, error) in
                completeHandler(value, message, error)
            })
            
        }
        task.resume()
    }
    
    func getCurrency(unmodified: Bool = false) -> String {
        if (self.currencyID as NSString).isEqualToString("CAD") && unmodified == false {
            return self.currencyID + String(" $")
        }
        return self.currencyID
    }
    
    func setCurrency(currencyID: String) {
        self.currencyID = currencyID
    }
    
    
    static func deleteItemFormCart(itemID: Int64, orderID: Int64, completeHandler: () -> Void) {
        let paramString = "xml=<ordered_item><delete_item><ID>"
            + String(itemID) + "</ID><customerOrderID>"
            + String(orderID) + "</customerOrderID></delete_item></ordered_item>"
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
            //print("Delete Item from cart : " + String(dataString))
            completeHandler()
        }
        task.resume()
    }
    
    static func GetOrdersList(userID: Int64, isFinalised: Bool, completeHandler: (ordersList: Array<Order>?) -> Void) {
        let finalized = isFinalised ? "<isFinalized>1</isFinalized>" : "<isFinalized>0</isFinalized>"
        
        let paramString = "xml=<order><list><userID>" + String(userID) + "</userID>" + finalized + "</list></order>"
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
            //print("Order List : " + dataString)
            XmlOrderParser().ParseOrder(data!, completeHandler: {(ordersList) in
                completeHandler(ordersList: ordersList)
                if ordersList != nil && ordersList?.count > 0 {
                    for order in ordersList! {
                        order.InitUserAddress()
                        order.InitOrderedItemOption({()in})
                    }
                }
            })
        }
        task.resume()
    }
    
    static func CreateNewOrder(userID: Int64, completeHandler: (ordersList: Array<Order>?) -> Void) {
        let paramString = "xml=<order><create><userID>" + String(userID) + "</userID></create></order>"
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
            //print("CreateNewOrder : " + dataString)
            XmlOrderParser().ParseOrder(data!, completeHandler: {(ordersList) in
                completeHandler(ordersList: ordersList)
                if ordersList != nil && ordersList?.count > 0 {
                    for order in ordersList! {
                        order.InitUserAddress()
                    }
                }
            })
        }
        task.resume()
    }
    
    static func GetOrderedProductCount(orderProductItems: Array<OrderProductItem>) -> Int {
        var count: Int = 0
        for item in orderProductItems {
            count += item.count
        }
        return count
    }
    
}

class OrderProductItem {
    var sku = String()
    var name = String()
    var ID = Int64()
    var productID = Int64()
    var customerOrderID = Int64()
    var shipmentID = Int64()
    private var price = Float32()
    var count = Int(1)
    var reservedProductCount = Int()
    var dateAdded = String()
    var isSavedForLater = Bool()
    
    var orderedItemOptionsList = [OrderedItemOption]()
    
    func GetPrice(calculateOptionsPrice: Bool = true) -> Float64 {
        var price: Float64 = (Float64)(self.price)
        if self.orderedItemOptionsList.count > 0 && calculateOptionsPrice == true {
            for item in self.orderedItemOptionsList {
                price += item.priceDiff
            }
        }
        return price
    }
    
    func SetPrice(price: Float32) {
        self.price = price
    }
    
    func InitOrderedItemOption(completeHandler:(Array<OrderedItemOption>) -> Void) {
        OrderedItemOption().GetOrderedItemOption(self.ID, completeHandler: {(orderedItemOptions, message, error) in
            if error == nil {
                self.orderedItemOptionsList = orderedItemOptions
                completeHandler(self.orderedItemOptionsList)
            }
        })
    }
}













