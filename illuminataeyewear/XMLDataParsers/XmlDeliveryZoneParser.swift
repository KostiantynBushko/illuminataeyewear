//
//  XmlDeliveryZoneParser.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/25/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class XmlDeliveryZoneParser: NSObject, NSXMLParserDelegate {
    
    static var TAG_RESPONSE = "response"
    static var TAG_DELIVERY_ZONE = "delivery_zone"
    
    var element = NSString()
    var xmlParser: NSXMLParser?
    
    var deliveryZoneList = [DeliveryZone]()
    var currentDeliveryZone = DeliveryZone()
    
    var name = String()
    
    var handler: ((Array<DeliveryZone>) -> Void)?
    
    
    func Parse(data: NSData, completeHandler: (Array<DeliveryZone>) -> Void) {
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
            currentDeliveryZone.ID = Int64(string)!
        } else if element.isEqualToString("name") {
            self.name.appendContentsOf(string)
        } else if element.isEqualToString("isEnabled") {
            currentDeliveryZone.isEnabled = Int(string)! == 1 ? true : false
        } else if element.isEqualToString("isFreeShipping") {
            currentDeliveryZone.isFreeShipping = Int(string)! == 1 ? true : false
        } else if element.isEqualToString("isRealTimeDisabled") {
            currentDeliveryZone.isRealTimeDisabled = Int(string)! == 1 ? true : false
        } else if element.isEqualToString("type") {
            currentDeliveryZone.type = Int32(string)!
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqualToString(XmlDeliveryZoneParser.TAG_DELIVERY_ZONE) {
            self.currentDeliveryZone.name = self.name.htmlDecoded()
            self.deliveryZoneList.append(currentDeliveryZone)
            self.name = String()
            self.currentDeliveryZone = DeliveryZone()
        } else if (elementName as NSString).isEqualToString(XmlDeliveryZoneParser.TAG_RESPONSE) {
            if handler != nil {
                handler!(self.deliveryZoneList)
            }
        }
    }
}
