//
//  XmlProductOptionParser.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 3/30/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation
import Kanna

class XmlProductOptionParser: NSObject, NSXMLParserDelegate {
    var TAG_RESPONSE = "response"
    var TAG_PRODUCT_OPTION = "product_option"
    
    var element = NSString()
    var xmlParser: NSXMLParser?
    
    var handler: ((Array<ProductOption>, String?, NSError?) -> Void)?

    
    var error: NSError?
    var message: String?
    
    var productOption = ProductOption()
    var productOptionList = [ProductOption]()
    
    var _description = String()
    var _selectMessage = String()
    var _name = String()
    
    func Parse(data: NSData, completeHandler: (Array<ProductOption>, String?, NSError?) -> Void) {
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
            self.productOption.ID = Int64(string)!
        } else if element.isEqualToString("productID") {
            self.productOption.productID = Int64(string)!
        } else if element.isEqualToString("categoryID") {
            self.productOption.categoryID = Int64(string)!
        } else if element.isEqualToString("defaultChoiceID") {
            self.productOption.defaultChoiceID = Int64(string)!
        } else if element.isEqualToString("name") {
            self._name.appendContentsOf(string)
        } else if element.isEqualToString("description") {
            self._description.appendContentsOf(string)
        } else if element.isEqualToString("selectMessage") {
            self._selectMessage.appendContentsOf(string)
        } else if element.isEqualToString("type") {
            self.productOption.type = Int64(string)!
        } else if element.isEqualToString("displayType") {
            self.productOption.displayType = Int64(string)!
        } else if element.isEqualToString("isRequired") {
            self.productOption.isRequired = Int(string)! == 1 ? true : false
        } else if element.isEqualToString("isDisplayed") {
            self.productOption.isDisplayed = Int(string)! == 1 ? true : false
        } else if element.isEqualToString("isDisplayedInList") {
            self.productOption.isDisplayedInList = Int(string)! == 1 ? true : false
        } else if element.isEqualToString("isDisplayedInCart") {
            self.productOption.isDisplayedInCart = Int(string)! == 1 ? true : false
        } else if element.isEqualToString("isPriceIncluded") {
            self.productOption.isPriceIncluded = Int(string)! == 1 ? true : false
        } else if element.isEqualToString("position") {
            self.productOption.position = Int(string)!
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
            handler!(self.productOptionList, message, error)
        } else if (elementName as NSString).isEqualToString(TAG_PRODUCT_OPTION) {
            self.productOption.description = self._description
            self.productOption.selectMessage = self._selectMessage
            
            if let doc = Kanna.HTML(html: self._name.htmlDecoded(), encoding: NSUTF8StringEncoding) {
                self.productOption.name = doc.text!
            } else {
                self.productOption.name = self._name.htmlDecoded()
            }
            
            self.productOptionList.append(productOption)
            
            self._description = String()
            self._selectMessage = String()
            self._name = String()
            self.productOption = ProductOption()
        }
    }
    

    /*var categoryID: Int32?
    var defaultChoiceID: Int32?
    var name = String()
    var description = String()
    var selectMessage = String()
    var type = Int32()
    var displayType = Int32()
    var isRequired = Bool()
    var isDisplayed = Bool()
    var isDisplayedInList = Bool()
    var isDisplayedInCart = Bool()
    var isPriceIncluded = Bool()
    var position = Int32()*/
}
