//
//  XmlNewsTextParser.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 1/25/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class XmlNewsTextParser: NSObject, NSXMLParserDelegate {
    
    var element = NSString()
    var xmlParser = NSXMLParser()
    
    var handler: ((simpleNewsPost: SimpleNewsPost) -> Void)?
    
    func ParseItem(data: NSData, callbackHandler: (simpleNewsPost: SimpleNewsPost) -> Void) {
        handler = callbackHandler
        xmlParser = NSXMLParser(data: data)
        xmlParser.delegate = self
        xmlParser.parse()
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        element = elementName
        if (elementName as NSString).isEqualToString("img") {
            print(" --- " + elementName)
            print(attributeDict)
        } else if (elementName as NSString).isEqualToString("p") {
            print(" --- " + elementName)
            print(attributeDict)
        } else if (elementName as NSString).isEqualToString("a") {
            print(" --- " + elementName)
            print(attributeDict)
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        print(string)
    }
}