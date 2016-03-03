//
//  XmlDeliveryZoneCountryParser.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/25/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class XmlDeliveryZoneCountryParser: NSObject, NSXMLParserDelegate {
    
    private var TAG_RESPONSE = "response"
    private var TAG_DELIVERY_ZONE_COUNTRY = "delivery_zone_country"
    
    var element = NSString()
    var xmlParser: NSXMLParser?
    
    var currentDeliveryZoneCountry = DeliveryZoneCountry()
    var deliveryZoneCountryList = [DeliveryZoneCountry]()
    
    var country_code = String()
    
    var handler: ((Array<DeliveryZoneCountry>) -> Void)?
    
    func Parse(data: NSData, completeHandler: (Array<DeliveryZoneCountry>) -> Void) {
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
            currentDeliveryZoneCountry.ID = Int64(string)!
        } else if element.isEqualToString("deliveryZoneID") {
            currentDeliveryZoneCountry.deliveryZoneID = Int64(string)!
        } else if element.isEqualToString("countryCode") {
            country_code.appendContentsOf(string)
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqualToString(TAG_DELIVERY_ZONE_COUNTRY) {
            currentDeliveryZoneCountry.countryCode = country_code
            deliveryZoneCountryList.append(currentDeliveryZoneCountry)
            currentDeliveryZoneCountry = DeliveryZoneCountry()
            country_code = String()
        } else if (elementName as NSString).isEqualToString(TAG_RESPONSE) {
            if handler != nil {
                handler!(deliveryZoneCountryList)
            }
        }
    }
}
