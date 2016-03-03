//
//  XmlShippingRateParser.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/26/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class XmlShippingRateParser: NSObject, NSXMLParserDelegate {
    
    var TAG_RESPONSE = "response"
    var TAG_SHIPPING_RATE = "shipping_rate"
    
    var element = NSString()
    var xmlParser: NSXMLParser?
    
    var currentShippingRate = ShippingRate()
    var shippingRateList = [ShippingRate]()
    
    var handler: ((Array<ShippingRate>) -> Void)?
    
    func Parser(data: NSData, completeHandler: (Array<ShippingRate>) -> Void) {
        handler = completeHandler
        xmlParser = NSXMLParser(data: data)
        xmlParser?.delegate = self
        xmlParser?.parse()
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        element = elementName
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if element.isEqualToString("") {
        
        } else if element.isEqualToString("ID") {
            currentShippingRate.ID = Int64(string)!
        } else if element.isEqualToString("shippingServiceID") {
            currentShippingRate.shippingServiceID = Int64(string)!
        } else if element.isEqualToString("weightRangeStart") {
            currentShippingRate.weightRangeStart = Float32(string)!
        } else if element.isEqualToString("weightRangeEnd") {
            currentShippingRate.weightRangeEnd = Float32(string)!
        } else if element.isEqualToString("subtotalRangeStart") {
            currentShippingRate.subtotalRangeStart = Float32(string)!
        } else if element.isEqualToString("subtotalRangeEnd") {
            currentShippingRate.subtotalRangeEnd = Float32(string)!
        } else if element.isEqualToString("flatCharge") {
            currentShippingRate.flatCharge = Float32(string)!
        } else if element.isEqualToString("perItemCharge") {
            currentShippingRate.perItemCharge = Float32(string)!
        } else if element.isEqualToString("subtotalPercentCharge") {
            currentShippingRate.subtotalPercentCharge = Float32(string)!
        } else if element.isEqualToString("perKgCharge") {
            currentShippingRate.perKgCharge = Float32(string)!
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqualToString(TAG_SHIPPING_RATE) {
            self.shippingRateList.append(self.currentShippingRate)
            self.currentShippingRate = ShippingRate()
        } else if (elementName as NSString).isEqualToString(TAG_RESPONSE) {
            if handler != nil {
                handler!(self.shippingRateList)
            }
        }
    }
    
}
