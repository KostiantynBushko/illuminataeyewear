//
//  XmlOrderNoteParser.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 4/8/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class XmlOrderNoteParser: NSObject, NSXMLParserDelegate {

    var TAG_RESPONSE = "response"
    var TAG_ORDER_NOTE = "note"
    
    var element = NSString()
    var xmlParser: NSXMLParser?
    
    var handler: ((Array<OrderNote>, String?, NSError?) -> Void)?

    private var orderNote = OrderNote()
    private var orderNotes = [OrderNote]()
    
    private var error: NSError?
    private var message: String?
    
    /*var ID = Int64()
    var userID = Int64()
    var orderID = Int64()
    var isRead = Bool()
    var isAdmin = Bool()*/
    var _time = String()
    var _text = String()
    
    func Parse(data: NSData, completeHandler: (Array<OrderNote>, String?, NSError?) -> Void) {
        handler = completeHandler
        xmlParser = NSXMLParser(data: data)
        xmlParser?.delegate = self
        xmlParser?.parse()
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        self.element = elementName
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if element.isEqualToString("ID") {
            self.orderNote.ID = Int64(string)!
        } else if element.isEqualToString("userID") {
            self.orderNote.userID = Int64(string)!
        } else if element.isEqualToString("orderID") {
            self.orderNote.orderID = Int64(string)!
        } else if element.isEqualToString("isRead") {
            self.orderNote.isRead = Int(string)! == 1 ? true : false
        } else if element.isEqualToString("isAdmin") {
            self.orderNote.isAdmin = Int(string) == 1 ? true : false
        } else if element.isEqualToString("time") {
            self._time.appendContentsOf(string)
        } else if element.isEqualToString("text") {
            self._text.appendContentsOf(string)
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
                self.handler!(self.orderNotes, self.message, self.error)
            }
        } else if (elementName as NSString).isEqualToString(TAG_ORDER_NOTE) {
            self.orderNote.time = self._time.htmlDecoded()
            self.orderNote.text = self._text.htmlDecoded()
            self.orderNote.text.htmlDecoded()
            self.orderNote.time.htmlDecoded()
            self.orderNotes.append(self.orderNote)
            self._time = String()
            self._text = String()
            self.orderNote = OrderNote()
        }
    }
    
}
