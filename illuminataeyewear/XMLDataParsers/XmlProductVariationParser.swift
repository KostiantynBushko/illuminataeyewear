//
//  XmlProductVariationParser.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/9/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class XmlProductVariationParser: NSObject, NSXMLParserDelegate {
    
    private static let TAG_RESPONSE = "response"
    private static let TAG_PRODUCT_VARIATION = "product_variation"
    
    var element = NSString()
    var xmlParser: NSXMLParser?
    var productVariation = ProductVariation()
    
    var name = String()
    
    var handler: ((ProductVariation) -> Void)?
    
    func Parse(data: NSData, completeHandler: (productVariation: ProductVariation) -> Void) {
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
            productVariation.setID(Int64(string)!)
        } else if element.isEqualToString("typeID") {
            productVariation.setTypeID(Int64(string)!)
        } else if element.isEqualToString("name") {
            self.name.appendContentsOf(string)
        } else if element.isEqualToString("position") {
            productVariation.setPosition(Int64(string)!)
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqualToString(XmlProductVariationParser.TAG_PRODUCT_VARIATION) {
            productVariation.setName(name)
        } else if (elementName as NSString).isEqualToString(XmlProductVariationParser.TAG_RESPONSE) {
            handler!(productVariation)
        }
    }
}
