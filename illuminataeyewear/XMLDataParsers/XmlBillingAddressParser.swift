//
//  XmlBillingAddressParser.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/17/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class XmlBillingAddressParser: NSObject, NSXMLParserDelegate {
    
    private static var TAG_BILLING_ADDRESS = "billing_address"
    private static var TAG_RESPONSE = "response"
    
    var element = NSString()
    var xmlParser: NSXMLParser?
    var currentBillingAddress = BillingAddress()
    var addresses = [BillingAddress]()
    
    var handler: ((Array<BillingAddress>) -> Void)?
    
    func Parse(data: NSData, completeHandler: (Array<BillingAddress>) -> Void) {
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
            currentBillingAddress.ID = Int32(string)!
        } else if element.isEqualToString("userID") {
            currentBillingAddress.userID = Int32(string)!
        } else if element.isEqualToString("userAddressID") {
            currentBillingAddress.userAddressID = Int32(string)!
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqualToString(XmlBillingAddressParser.TAG_RESPONSE) {
            if handler != nil {
                handler!(addresses)
            }
        } else if (elementName as NSString).isEqualToString(XmlBillingAddressParser.TAG_BILLING_ADDRESS) {
            addresses.append(currentBillingAddress)
        }
    }
}
