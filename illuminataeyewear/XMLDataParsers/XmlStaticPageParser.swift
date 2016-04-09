//
//  XmlStaticPageParser.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 4/8/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class XmlStaticPageParser: NSObject, NSXMLParserDelegate {
    var TAG_RESPONSE = "response"
    var TAG_STATIC_PAGE = "static_page"
    
    var element = NSString()
    var xmlParser: NSXMLParser?
    
    var handler: ((Array<StaticPage>, String?, NSError?) -> Void)?
    
    
    var staticPages = [StaticPage]()
    var staticPage = StaticPage()
    
    private var error: NSError?
    private var message: String?
    
    private var _handler = String()
    private var _title = String()
    private var _text = String()
    private var _metaDescription = String()
    
    func Parse(data: NSData, completeHandler: (Array<StaticPage>, String?, NSError?) -> Void) {
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
            self.staticPage.ID = Int64(string)!
        } else if self.element.isEqualToString("parentID") {
            self.staticPage.parentID = Int64(string)!
        } else if self.element.isEqualToString("handle") {
            self._handler.appendContentsOf(string.htmlDecoded())
        } else if self.element.isEqualToString("title") {
            self._title.appendContentsOf(string.htmlDecoded())
        } else if self.element.isEqualToString("text") {
            self._text.appendContentsOf(string.htmlDecoded())
        } else if self.element.isEqualToString("metaDescription") {
            self._metaDescription.appendContentsOf(string.htmlDecoded())
        } else if self.element.isEqualToString("menu") {
            self.staticPage.menu = Int64(string)!
        } else if self.element.isEqualToString("position") {
            self.staticPage.position = Int64(string)!
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
                self.handler!(self.staticPages, self.message, self.error)
            }
        } else if (elementName as NSString).isEqualToString(TAG_STATIC_PAGE) {
            self.staticPage.handle = self._handler.htmlDecoded()
            self.staticPage.title = self._title.htmlDecoded()
            self.staticPage.text = self._text.htmlDecoded()
            self.staticPage.metaDescription = self._metaDescription.htmlDecoded()
            self.staticPages.append(self.staticPage)
            self.staticPage = StaticPage()
            self._handler = String()
            self._title = String()
            self._text = String()
            self._metaDescription = String()
        }
    }
    
    /*var ID = Int64()
    var parentID = Int64()
    var handle = String()
    var title = String()
    var text = String()
    var metaDescription = String()
    var menu = Int64()
    var position = Int64()*/
}
