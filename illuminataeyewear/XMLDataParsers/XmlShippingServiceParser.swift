//
//  XmlShippingServiceParser.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/20/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class XmlShippingServiceParser: NSObject, NSXMLParserDelegate {

    private static var TAG_RESPONSE = "response"
    private static var TAG_SHIPPING_SERVICE = "shipping_service"
    
    var element = NSString()
    var xmlParser: NSXMLParser?
    
    var servicesList = [ShippingService]()
    var currentService = ShippingService()
    
    var _name = String()
    var _description = String()
    
    var handler: ((Array<ShippingService>) -> Void)?
    
    func Parse(data: NSData, completeHandler: (Array<ShippingService>) -> Void) {
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
            currentService.ID = Int64(string)!
        } else if element.isEqualToString("deliveryZoneID") {
            currentService.deliveryZoneID = Int64(string)!
        } else if element.isEqualToString("isFinal") {
            currentService.isFinal = Int(string) == 1 ? true : false
        } else if element.isEqualToString("name") {
            self._name.appendContentsOf(string)
        } else if element.isEqualToString("position") {
            currentService.position = Int32(string)!
        } else if element.isEqualToString("rangeType") {
            currentService.rangeType = Int32(string)!
        } else if element.isEqualToString("description") {
            self._description.appendContentsOf(string)
        } else if element.isEqualToString("deliveryTimeMinDays") {
            currentService.deliveryTimeMinDays = Int32(string)!
        } else if element.isEqualToString("deliveryTimeMaxDays") {
            currentService.deliveryTimeMaxDays = Int32(string)!
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqualToString(XmlShippingServiceParser.TAG_SHIPPING_SERVICE) {
            currentService.name = self._name.htmlDecoded()
            currentService.description = self._description.htmlDecoded()
            servicesList.append(currentService)
            self._name = String()
            self._description = String()
            currentService = ShippingService()
        } else if (elementName as NSString).isEqualToString(XmlShippingServiceParser.TAG_RESPONSE) {
            if handler != nil {
                handler!(servicesList)
            }
        }
    }
}
