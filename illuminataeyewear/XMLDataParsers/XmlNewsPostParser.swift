//
//  XmlNewsPostParser.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 1/23/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation


class XmlNewsPosParser: NSObject, NSXMLParserDelegate {
    
    var element = NSString()
    var xmlParser = NSXMLParser()
    
    var currentNewsPostItem = NewsPost()
    var newsPostItems = [NewsPost]()
    
    var handler: ((newsPostItems: Array<NewsPost>) -> Void)?
    
    func ParseItems(data: NSData, completeHandler: (newsPostItems: Array<NewsPost>) -> Void) {
        handler = completeHandler
        xmlParser = NSXMLParser(data: data)
        xmlParser.delegate = self
        xmlParser.parse()
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        element = elementName
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if element.isEqualToString("ID") {
            currentNewsPostItem.ID = Int(string)!
        } else if element.isEqualToString("isEnabled") {
            currentNewsPostItem.isEnabled = Int(string) == 1 ? true : false
        } else if element.isEqualToString("position") {
            currentNewsPostItem.position = Int(string)!
        } else if element.isEqualToString("time") {
            currentNewsPostItem.time.appendContentsOf(string)
        } else if element.isEqualToString("title") {
            currentNewsPostItem.title.appendContentsOf(string)
        } else if element.isEqualToString("text") {
            currentNewsPostItem.text.appendContentsOf(string)
        } else if element.isEqualToString("moreText") {
            currentNewsPostItem.moreText.appendContentsOf(string)
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqualToString("response") {
            handler!(newsPostItems: newsPostItems)
        } else if (elementName as NSString).isEqualToString("newspost") {
            if currentNewsPostItem.isEnabled {
                currentNewsPostItem.title.htmlDecoded()
                currentNewsPostItem.text.htmlDecoded()
                currentNewsPostItem.moreText.htmlDecoded()
                newsPostItems.append(currentNewsPostItem)
            }
            currentNewsPostItem = NewsPost()
        }
    }
    
}
