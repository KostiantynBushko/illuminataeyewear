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
    
    private var error: NSError?
    private var message: String?
    
    var element = NSString()
    var xmlParser: NSXMLParser?
    var currentBillingAddress = BillingAddress()
    var addresses = [BillingAddress]()
    
    var handler: ((Array<BillingAddress>, String?, NSError?) -> Void)?
    
    func Parse(data: NSData, completeHandler: (Array<BillingAddress>, String?, NSError?) -> Void) {
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
            currentBillingAddress.ID = Int64(string)!
        } else if element.isEqualToString("userID") {
            currentBillingAddress.userID = Int64(string)!
        } else if element.isEqualToString("userAddressID") {
            currentBillingAddress.userAddressID = Int64(string)!
        } else if element.isEqualToString("error") {
            let userInfo: [NSObject : AnyObject] =
                [
                    NSLocalizedDescriptionKey :  NSLocalizedString("error", value: string, comment: ""),
                    NSLocalizedFailureReasonErrorKey : NSLocalizedString("error", value: string, comment: "")
            ]
            self.error = NSError(domain: "illuminataeyewear.com", code: 401, userInfo: userInfo)
        } else if element.isEqualToString("message") {
            self.message = string
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqualToString(XmlBillingAddressParser.TAG_RESPONSE) {
            if handler != nil {
                handler!(addresses, message, error)
            }
        } else if (elementName as NSString).isEqualToString(XmlBillingAddressParser.TAG_BILLING_ADDRESS) {
            addresses.append(currentBillingAddress)
        }
    }
}
