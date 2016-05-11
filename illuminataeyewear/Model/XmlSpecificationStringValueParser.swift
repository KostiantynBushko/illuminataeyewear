//
//  XmlSpecificationStringValueParser.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 4/14/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class XmlSpecificationStringValueParser: NSObject, NSXMLParserDelegate {

    var TAG_RESPONSE = "response"
    var TAG_STRING_VALUE = "string_value"
    
    var element = NSString()
    var xmlParser: NSXMLParser?
    
    var handler: ((Array<SpecificationStringValue>, String?, NSError?) -> Void)?
    
    private var specificationStringValue = SpecificationStringValue()
    private var specificationStringValues = [SpecificationStringValue]()
    
    private var error: NSError?
    private var message: String?
    
    private var _value = String()
    
    func Parse(data: NSData, completeHandler: (Array<SpecificationStringValue>, String?, NSError?) -> Void) {
        handler = completeHandler
        xmlParser = NSXMLParser(data: data)
        xmlParser?.delegate = self
        xmlParser?.parse()
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        self.element = elementName
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if self.element.isEqualToString("productID") {
            self.specificationStringValue.productID = Int64(string)!
        } else if element.isEqualToString("specFieldID") {
            self.specificationStringValue.specFieldID = Int64(string)!
        } else if element.isEqualToString("value") {
            self._value.appendContentsOf(string.htmlDecoded())
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
                handler!(self.specificationStringValues, self.message, self.error)
            }
        } else if (elementName as NSString).isEqualToString(TAG_STRING_VALUE) {
            self.specificationStringValue.value = self._value.htmlDecoded()
            self.specificationStringValues.append(self.specificationStringValue)
            self.specificationStringValue = SpecificationStringValue()
            self._value = String()
        }
    }
    
    /*var productID = Int64()
    var specFieldID = Int64()
    var value = String()*/
}
