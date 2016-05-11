//
//  XmlSpecFieldParser.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 4/14/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class XmlSpecFieldParser: NSObject, NSXMLParserDelegate {

    var TAG_RESPONSE = "response"
    var TAG_SPEC_FIELD = "spec_field"
    
    var element = NSString()
    var xmlParser: NSXMLParser?
    
    var handler: ((Array<SpecField>, String?, NSError?) -> Void)?
    
    private var specField = SpecField()
    private var specFields = [SpecField]()
    
    private var error: NSError?
    private var message: String?
    
    private var _name = String()
    private var _description = String()
    private var _handle = String()
    private var _valuePrefix = String()
    private var _valueSuffix = String()
    
    
    func Parse(data: NSData, completeHandler: (Array<SpecField>, String?, NSError?) -> Void) {
        handler = completeHandler
        xmlParser = NSXMLParser(data: data)
        xmlParser?.delegate = self
        xmlParser?.parse()
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        self.element = elementName
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if self.element.isEqualToString("ID") {
            self.specField.ID = Int64(string)!
        } else if self.element.isEqualToString("specFieldGroupID") {
            self.specField.specFieldGroupID = Int64(string)!
        } else if self.element.isEqualToString("name") {
            self._name.appendContentsOf(string.htmlDecoded())
        } else if self.element.isEqualToString("description") {
            self._description.appendContentsOf(string.htmlDecoded())
        } else if self.element.isEqualToString("type") {
            self.specField.type = Int64(string)!
        } else if self.element.isEqualToString("dataType") {
            self.specField.dataType = Int64(string)!
        } else if self.element.isEqualToString("position") {
            self.specField.position = Int64(string)!
        } else if self.element.isEqualToString("handle") {
            self._handle.appendContentsOf(string.htmlDecoded())
        } else if self.element.isEqualToString("isMultiValue") {
            self.specField.isMultiValue = Int(string)! == 1 ? true : false
        } else if self.element.isEqualToString("isRequired") {
            self.specField.isRequired = Int(string)! == 1 ? true : false
        } else if self.element.isEqualToString("isDisplayed") {
            self.specField.isDisplayed = Int(string)! == 1 ? true : false
        } else if self.element.isEqualToString("isDisplayedInList") {
            self.specField.isDisplayedInList = Int(string)! == 1 ? true : false
        } else if self.element.isEqualToString("valuePrefix") {
            self._valuePrefix.appendContentsOf(string.htmlDecoded())
        } else if self.element.isEqualToString("valueSuffix") {
            self._valueSuffix.appendContentsOf(string.htmlDecoded())
        } else if self.element.isEqualToString("categoryID") {
            self.specField.categoryID = Int64(string)!
        } else if self.element.isEqualToString("isSortable") {
            self.specField.isSortable = Int(string)! == 1 ? true : false
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
            if self.handler != nil {
                handler!(self.specFields, self.message, self.error)
            }
        } else if (elementName as NSString).isEqualToString(TAG_SPEC_FIELD) {
            self.specField.name = self._name.htmlDecoded()
            self.specField.description = self._description.htmlDecoded()
            self.specField.handle = self._handle.htmlDecoded()
            self.specField.valuePrefix = self._valuePrefix.htmlDecoded()
            self.specField.valueSuffix = self._valueSuffix.htmlDecoded()
            self.specFields.append(self.specField)
            self.specField = SpecField()
            self._name = String()
            self._description = String()
            self._handle = String()
            self._valuePrefix = String()
            self._valueSuffix = String()
        }
    }
    
    /*var ID = Int64()
    var specFieldGroupID = Int64()
    var name = String()
    var description = String()
    var type = Int64()
    var dataType = Int64()
    var position = Int64()
    var handle = String()
    var isMultiValue = Bool()
    var isRequired = Bool()
    var isDisplayed = Bool()
    var isDisplayedInList = Bool()
    var valuePrefix = String()
    var valueSuffix = String()
    var categoryID = Int64()
    var isSortable = Bool()*/
}
