//
//  XmlShippingAddressParser.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/17/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class XmlShippingAddressParser: NSObject, NSXMLParserDelegate {
    
    private static var TAG_SHIPPING_ADDRESS = "shipping_address"
    private static var TAG_RESPONSE = "response"
    
    var element = NSString()
    var xmlParser: NSXMLParser?
    var currentShippingAddress = ShippingAddress()
    var addresses = [ShippingAddress]()
    
    var handler: ((Array<ShippingAddress>) -> Void)?
    
    func Parse(data: NSData, completeHandler: (Array<ShippingAddress>) -> Void) {
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
            currentShippingAddress.ID = Int32(string)!
        } else if element.isEqualToString("userID") {
            currentShippingAddress.userID = Int32(string)!
        } else if element.isEqualToString("userAddressID") {
            currentShippingAddress.userAddressID = Int32(string)!
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqualToString(XmlShippingAddressParser.TAG_RESPONSE) {
            if handler != nil {
                handler!(addresses)
            }
        } else if (elementName as NSString).isEqualToString(XmlShippingAddressParser.TAG_SHIPPING_ADDRESS) {
            addresses.append(currentShippingAddress)
        }
    }
}
