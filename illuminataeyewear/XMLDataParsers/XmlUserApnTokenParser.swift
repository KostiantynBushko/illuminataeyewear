//
//  XmlUserApnTokenParser.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 3/6/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class XmlUserApnTokenParser: NSObject, NSXMLParserDelegate {
    
    var TAG_RESPONSE = "response"
    var TAG_SHIPPING_RATE = "user_apn_token"
    
    var element = NSString()
    var xmlParser: NSXMLParser?
    
    var handler: ((UserApnToken) -> Void)?
    var userApnToken = UserApnToken()
    
    func Parse(data: NSData, completeHandler: (UserApnToken) -> Void) {
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
            self.userApnToken.setID(Int64(string)!)
        } else if element.isEqualToString("userID") {
            self.userApnToken.setUserID(Int64(string)!)
        } else if element.isEqualToString("token") {
            self.userApnToken.setToken(string)
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqualToString(TAG_RESPONSE) {
            handler!(self.userApnToken)
        }
    }
}
