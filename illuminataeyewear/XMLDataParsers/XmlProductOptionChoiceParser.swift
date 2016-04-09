//
//  XmlProductOptionChoiceParser.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 4/1/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation
import Kanna


class XmlProductOptionChoiceParser: NSObject, NSXMLParserDelegate {
    var TAG_RESPONSE = "response"
    var TAG_PRODUCT_OPTION_CHOICE = "product_option_choice"
    
    var element = NSString()
    var xmlParser: NSXMLParser?
    
    var handler: ((Array<ProductOptionChoice>, String?, NSError?) -> Void)?
    
    var error: NSError?
    var message: String?
    
    var optionChoice = ProductOptionChoice()
    var optionChoiceList = [ProductOptionChoice]()
    
    var _name = String()
    
    
    func Parse(data: NSData, completeHandler: (Array<ProductOptionChoice>, String?, NSError?) -> Void) {
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
            self.optionChoice.ID = Int64(string)!
        } else if element.isEqualToString("optionID") {
            self.optionChoice.optionID = Int64(string)!
        } else if element.isEqualToString("priceDiff") {
            self.optionChoice.priceDiff = Float64(string)
        } else if element.isEqualToString("hasImage") {
            self.optionChoice.hasImage = Int(string)! == 1 ? true : false
        } else if element.isEqualToString("position") {
            self.optionChoice.position = Int(string)!
        } else if element.isEqualToString("name") {
            self._name.appendContentsOf(string)
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
            handler!(self.optionChoiceList, self.message, self.error)
         
        } else if (elementName as NSString).isEqualToString(TAG_PRODUCT_OPTION_CHOICE) {
            if let doc = Kanna.HTML(html: self._name, encoding: NSUTF8StringEncoding) {
                self.optionChoice.name = doc.text!
            } else {
                self.optionChoice.name = self._name
            }
            self.optionChoiceList.append(self.optionChoice)
            self.optionChoice = ProductOptionChoice()
            self._name = String()
        }
    }
    
}
