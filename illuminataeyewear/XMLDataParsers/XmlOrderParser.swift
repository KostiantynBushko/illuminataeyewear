//
//  XmlOrderParser.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 1/29/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//


import Foundation

class XmlOrderParser: NSObject, NSXMLParserDelegate {

    var TAG_RESPONSE = "response"
    var TAG_ORDER = "order"
    var TAG_PRODUCT = "Product"
    
    var isTagProduct: Bool = false
    var element = NSString()
    var xmlParser = NSXMLParser()
    
    var currentOrder = Order()
    var currentProduct = OrderProductItem()
    var ordersList = [Order]()
    var orderProducstList = [OrderProductItem]()
    
    
    var handler: ((ordersList: Array<Order>) -> Void)?
    
    func ParseOrder(data: NSData, completeHandler: (ordersList: Array<Order>?) -> Void) {
        handler = completeHandler
        xmlParser = NSXMLParser(data: data)
        xmlParser.delegate = self
        xmlParser.parse()
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        element = elementName
        if element.isEqualToString(TAG_PRODUCT) {
            isTagProduct = true
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if !isTagProduct {
            if element.isEqualToString("ID"){
                currentOrder.ID = Int64(string)!
            } else if element.isEqualToString("userID") {
                currentOrder.userID = Int64(string)!
            } else if element.isEqualToString("shippingAddressID") {
                currentOrder.shippingAddressID = Int64(string)!
            } else if element.isEqualToString("billingAddressID") {
                currentOrder.billingAddressID = Int64(string)!
            } else if element.isEqualToString("currencyID") {
                currentOrder.currencyID = string
            } else if element.isEqualToString("eavObjectID") {
                currentOrder.eavObjectID = Int64(string)!
            } else if element.isEqualToString("invoiceNumber") {
                currentOrder.invoiceNumber = Int64(string)!
            } else if element.isEqualToString("checkoutStep") {
                currentOrder.checkoutStep = Int(string)!
            } else if element.isEqualToString("dateCreated") {
                currentOrder.dateCreated = string
            } else if element.isEqualToString("dateCompleted") {
                currentOrder.dateCompleted = string
            } else if element.isEqualToString("totalAmount") {
                currentOrder.totalAmount = Float32(string)!
            } else if element.isEqualToString("capturedAmount") {
                currentOrder.capturedAmount = Int(string)!
            } else if element.isEqualToString("isMultiAddress") {
                currentOrder.isMultiAddress = Int(string) == 1 ? true : false
            } else if element.isEqualToString("isFinalized") {
                currentOrder.isFinalized = Int(string) == 1 ? true : false
            } else if element.isEqualToString("isPaid") {
                currentOrder.isPaid = Int(string) == 1 ? true : false
            } else if element.isEqualToString("isCancelled") {
                currentOrder.isCancelled = Int(string) == 1 ? true : false
            } else if element.isEqualToString("status") {
                currentOrder.status = Int(string)!
            } else if element.isEqualToString("User_userGroupID") {
                currentOrder.User_userGroupID = Int(string)!
            } else if element.isEqualToString("User_email") {
                currentOrder.User_email = string
            } else if element.isEqualToString("User_firstName") {
                currentOrder.User_firstName = string
            } else if element.isEqualToString("User_lastName") {
                currentOrder.User_lastName = string
            } else if element.isEqualToString("User_companyName") {
                currentOrder.User_companyName = string
            }
            
            else if element.isEqualToString("ShippingAddress_stateID") {
                currentOrder.shippingAddressID = Int64(string)!
            } else if element.isEqualToString("ShippingAddress_phone") {
                currentOrder.ShippingAddress_phone = string
            } else if element.isEqualToString("ShippingAddress_firstName") {
                currentOrder.ShippingAddress_firstName = string
            } else if element.isEqualToString("ShippingAddress_lastName") {
                currentOrder.ShippingAddress_lastName = string
            } else if element.isEqualToString("ShippingAddress_companyName") {
                currentOrder.ShippingAddress_companyName = string
            } else if element.isEqualToString("ShippingAddress_address1") {
                currentOrder.ShippingAddress_address1 = string
            } else if element.isEqualToString("ShippingAddress_address2") {
                currentOrder.ShippingAddress_address2 = string
            } else if element.isEqualToString("ShippingAddress_city") {
                currentOrder.ShippingAddress_city = string
            } else if element.isEqualToString("ShippingAddress_stateName") {
                currentOrder.ShippingAddress_stateName = string
            } else if element.isEqualToString("ShippingAddress_postalCode") {
                currentOrder.ShippingAddress_postalCode = string
            } else if element.isEqualToString("ShippingAddress_countryID") {
                currentOrder.ShippingAddress_countryID = string
            } else if element.isEqualToString("ShippingAddress_countryName") {
                currentOrder.ShippingAddress_countryName = string
            } else if element.isEqualToString("ShippingAddress_fullName") {
                currentOrder.ShippingAddress_fullName = string
            } else if element.isEqualToString("ShippingAddress_compact") {
                currentOrder.ShippingAddress_compact = string
            }
            
            
            else if element.isEqualToString("BillingAddress_stateID") {
                currentOrder.BillingAddress_stateID = Int64(string)!
            } else if element.isEqualToString("BillingAddress_phone") {
                currentOrder.BillingAddress_phone = string
            } else if element.isEqualToString("BillingAddress_firstName") {
                currentOrder.BillingAddress_firstName = string
            } else if element.isEqualToString("BillingAddress_lastName") {
                currentOrder.BillingAddress_lastName = string
            } else if element.isEqualToString("BillingAddress_companyName") {
                currentOrder.BillingAddress_companyName = string
            } else if element.isEqualToString("BillingAddress_address1") {
                currentOrder.BillingAddress_address1 = string
            } else if element.isEqualToString("BillingAddress_address2") {
                currentOrder.BillingAddress_address2 = string
            } else if element.isEqualToString("BillingAddress_city") {
                currentOrder.BillingAddress_city = string
            } else if element.isEqualToString("BillingAddress_stateName") {
                currentOrder.BillingAddress_stateName = string
            } else if element.isEqualToString("BillingAddress_postalCode") {
                currentOrder.BillingAddress_postalCode = string
            } else if element.isEqualToString("BillingAddress_countryID") {
                currentOrder.BillingAddress_countryID = string
            } else if element.isEqualToString("BillingAddress_countryName") {
                currentOrder.BillingAddress_countryName = string
            } else if element.isEqualToString("BillingAddress_fullName") {
                currentOrder.BillingAddress_fullName = string
            } else if element.isEqualToString("BillingAddress_compact") {
                currentOrder.BillingAddress_compact = string
            }
            
        } else {
            if element.isEqualToString("sku") {
                currentProduct.sku = string
            } else if element.isEqualToString("name") {
                currentProduct.name = string
            } else if element.isEqualToString("ID") {
                currentProduct.ID = Int64(string)!
            } else if element.isEqualToString("productID") {
                currentProduct.productID = Int64(string)!
            }else if element.isEqualToString("customerOrderID") {
                currentProduct.customerOrderID = Int64(string)!
            } else if element.isEqualToString("shipmentID") {
                currentProduct.shipmentID = Int64(string)!
            } else if element.isEqualToString("price") {
                currentProduct.price = string
            } else if element.isEqualToString("count") {
                currentProduct.count = Int(string)!
            } else if element.isEqualToString("reservedProductCount") {
                currentProduct.reservedProductCount = Int(string)!
            } else if element.isEqualToString("dateAdded") {
                currentProduct.dateAdded = string
            } else if element.isEqualToString("isSavedForLater") {
                currentProduct.isSavedForLater = Int(string) == 1 ? true : false
            }
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqualToString(TAG_ORDER) {
            ordersList.append(currentOrder)
            currentOrder = Order()
        } else if (elementName as NSString).isEqualToString(TAG_PRODUCT) {
            currentOrder.productItems.append(currentProduct)
            currentProduct = OrderProductItem()
            isTagProduct = false
        } else if (elementName as NSString).isEqualToString(TAG_RESPONSE) {
            handler!(ordersList: ordersList)
        }
    }
    
}
