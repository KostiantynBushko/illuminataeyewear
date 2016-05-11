//
//  XmlShipmentParser.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/22/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class XmlShipmentParser: NSObject, NSXMLParserDelegate {
    
    private static var TAG_RESPONSE = "response"
    private static var TAG_SHIPMENT  = "shipment"
    
    var element = NSString()
    var xmlParser: NSXMLParser?
    
    var currentShipment = Shipment()
    var shipmentList = [Shipment]()
    
    var trackingCode = String()
    var dateShipped = String()
    var shippingServiceData = String()
    
    var handler: ((Array<Shipment>) -> Void)?

    
    func Parse(data: NSData, completeHandler: (Array<Shipment>) -> Void) {
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
            currentShipment.ID = Int64(string)!
        } else if element.isEqualToString("orderID") {
            currentShipment.orderID = Int64(string)!
        } else if element.isEqualToString("shippingServiceID") {
            currentShipment.shippingServiceID = Int64(string)!
        } else if element.isEqualToString("shippingAddressID") {
            currentShipment.shippingAddressID = Int64(string)!
        } else if element.isEqualToString("trackingCode") {
            self.trackingCode.appendContentsOf(string)
        } else if element.isEqualToString("dateShipped") {
            self.dateShipped.appendContentsOf(string)
        } else if element.isEqualToString("amount") {
            currentShipment.amount = Float32(string)!
        } else if element.isEqualToString("taxAmount") {
            currentShipment.taxAmount = Float32(string)!
        } else if element.isEqualToString("shippingAmount") {
            currentShipment.shippingAmount = Float32(string)!
        } else if element.isEqualToString("status") {
            currentShipment.status = Int32(string)!
        } else if element.isEqualToString("shippingServiceData") {
            self.shippingServiceData.appendContentsOf(string)
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqualToString(XmlShipmentParser.TAG_RESPONSE) {
            if self.handler != nil {
                handler!(shipmentList)
            }
        } else if (elementName as NSString).isEqualToString(XmlShipmentParser.TAG_SHIPMENT) {
            currentShipment.trackingCode = self.trackingCode.htmlDecoded()
            currentShipment.dateShipped = self.dateShipped.htmlDecoded()
            currentShipment.shippingServiceData = self.shippingServiceData.htmlDecoded()
            shipmentList.append(currentShipment)
            currentShipment = Shipment()
        }
    }
}
