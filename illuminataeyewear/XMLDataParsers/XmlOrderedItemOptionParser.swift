//
//  XmlOrderedItemOptionParser.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 4/1/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation
import Kanna

class XmlOrderedItemOptionParser: NSObject, NSXMLParserDelegate {
    var TAG_RESPONSE = "response"
    var TAG_ORDERED_ITEM_OPTION = "option"
    
    var element = NSString()
    var xmlParser: NSXMLParser?
    
    var handler: ((Array<OrderedItemOption>, String?, NSError?) -> Void)?
    
    var error: NSError?
    var message: String?
    
    var orderedItemOption = OrderedItemOption()
    var orderedItemOptionsList = [OrderedItemOption]()
    
    var optionsText = String()
    
    func Parse(data: NSData, completeHandler: (Array<OrderedItemOption>, String?, NSError?) -> Void) {
        handler = completeHandler
        xmlParser = NSXMLParser(data: data)
        xmlParser?.delegate = self
        xmlParser?.parse()
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        element = elementName
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if element.isEqualToString("orderedItemID") {
            self.orderedItemOption.orderedItemID = Int64(string)!
        } else if element.isEqualToString("choiceID") {
            self.orderedItemOption.choiceID = Int64(string)!
        } else if element.isEqualToString("priceDiff") {
            self.orderedItemOption.priceDiff = Float64(string)!
        } else if element.isEqualToString("optionText") {
            self.optionsText.appendContentsOf(string)
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
                handler!(orderedItemOptionsList, message, error)
            }
        } else if (elementName as NSString).isEqualToString(TAG_ORDERED_ITEM_OPTION) {
            if let doc = Kanna.HTML(html: self.optionsText, encoding: NSUTF8StringEncoding) {
                self.orderedItemOption.optionText = doc.text!
            } else {
                self.orderedItemOption.optionText = self.optionsText
            }
            self.orderedItemOptionsList.append(self.orderedItemOption)
            self.optionsText = String()
            self.orderedItemOption = OrderedItemOption()
        }
    }
}
