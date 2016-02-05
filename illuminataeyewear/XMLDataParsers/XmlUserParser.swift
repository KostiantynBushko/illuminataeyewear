//
//  XmlUserParser.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/2/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class XmlUserParser: NSObject, NSXMLParserDelegate {
    
    var TAG_RESPONSE = "response"
    var TAG_CUSTOMER = "customer"
    
    var element = NSString()
    var xmlParser = NSXMLParser()
    
    var user: User?
    
    var lastName = String()
    var firstName = String()
    var email = String()
    var companyName = String()
    var locale = String()
    var dateCreated = String()
    
    var handler: ((user: User?) -> Void)?
    
    
    func ParseUser(data: NSData, completeHandler:(user: User?) -> Void) {
        handler = completeHandler
        xmlParser = NSXMLParser(data: data)
        xmlParser.delegate = self
        xmlParser.parse()
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        element = elementName
        if element.isEqualToString(TAG_CUSTOMER) {
            user = User()
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if element.isEqualToString("ID") {
            user?.ID = Int64(string)!
        } else if element.isEqualToString("defaultShippingAddressID") {
            user?.defaultShippingAddressID = Int64(string)!
        } else if element.isEqualToString("defaultBillingAddressID") {
            user?.defaultBillingAddressID = Int64(string)!
        } else if element.isEqualToString("userGroupID") {
            user?.userGroupID = Int64(string)!
        } else if element.isEqualToString("eavObjectID") {
            user?.eavObjectID = Int64(string)!
        } else if element.isEqualToString("locale") {
            locale.appendContentsOf(string)
        } else if element.isEqualToString("email") {
            email.appendContentsOf(string)
        } else if element.isEqualToString("firstName") {
            firstName.appendContentsOf(string)
        } else if element.isEqualToString("lastName") {
            lastName.appendContentsOf(string)
        } else if element.isEqualToString("companyName") {
            companyName.appendContentsOf(string)
        } else if element.isEqualToString("dateCreated") {
            dateCreated.appendContentsOf(string)
        } else if element.isEqualToString("isEnabled") {
            user?.isEnabled = Int(string) == 1 ? true : false
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqualToString(TAG_RESPONSE) {
            handler!(user: user)
        } else if (elementName as NSString).isEqualToString(TAG_CUSTOMER) {
            user?.email = email.htmlDecoded()
            user?.firstName = firstName.htmlDecoded()
            user?.lastName = lastName.htmlDecoded()
            user?.companyName = companyName.htmlDecoded()
            user?.locale = locale.htmlDecoded()
            user?.dateCreated = dateCreated.htmlDecoded()
        }
    }
}








