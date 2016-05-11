//
//  XmlFloatValueParser.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 4/16/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class XmlFloatValueParser: NSObject, NSXMLParserDelegate {
    var TAG_RESPONSE = "response"
    
    
    var element = NSString()
    var xmlParser: NSXMLParser?
    
    var handler: ((Float32, String?, NSError?) -> Void)?
    
    private var error: NSError?
    private var message: String?
    
    private var value = Float32()
    
    private var tag = String()
    
    func Parse(data: NSData, completeHandler: (Float32, String?, NSError?) -> Void) {
        handler = completeHandler
        xmlParser = NSXMLParser(data: data)
        xmlParser?.delegate = self
        xmlParser?.parse()
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        self.element = elementName
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if element.isEqualToString("value") {
            self.value = Float32(string)!
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
        if (elementName as NSString).isEqualToString(TAG_RESPONSE) {
            if handler != nil {
                handler?(self.value, message, error)
            }
        }
    }
}
