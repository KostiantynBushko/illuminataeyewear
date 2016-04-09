//
//  XmlSimpleStateParser.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 3/14/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class XmlSimpleStateParser: NSObject, NSXMLParserDelegate  {
    
    var TAG_RESPONSE = "response"
    var TAG_STATE = "state"
    var TAG_ERROR = "error"
    
    var element = NSString()
    var xmlParser: NSXMLParser?
    
    var handler: ((Bool, NSError?) -> Void)?
    var state: Bool = false
    var error: NSError?
    
    func Parse(data: NSData, completeHandler: (Bool, NSError?) -> Void) {
        handler = completeHandler
        xmlParser = NSXMLParser(data: data)
        xmlParser?.delegate = self
        xmlParser?.parse()
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        element = elementName
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if element.isEqualToString(TAG_STATE) {
            self.state = Int64(string)! == 1 ? true : false
        } else if element.isEqualToString(TAG_ERROR) {
            self.error = NSError(domain: "error", code: 0, userInfo: [NSLocalizedDescriptionKey: string])
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqualToString(TAG_RESPONSE) {
            if handler != nil {
                handler!(self.state, self.error)
            }
        }
    }
}
