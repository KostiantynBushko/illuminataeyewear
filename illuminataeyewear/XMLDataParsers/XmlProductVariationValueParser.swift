//
//  XmlProductVariationValueParser.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/9/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class XmlProductVariationValueParser: NSObject, NSXMLParserDelegate {
    
    private static var TAG_PRODUCT_VARIATION_VALUE = "product_variation_value"
    private static var TAG_RESPONSE = "response"
    
    var element = NSString()
    var xmlParser: NSXMLParser?
    var productVariationValue = ProductVariationValue()
    
    var handler: ((ProductVariationValue) -> Void)?
    
    func Parse(data: NSData, completeHandler: (productVariation: ProductVariationValue) -> Void) {
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
            productVariationValue.setID(Int64(string)!)
        } else if element.isEqualToString("productID") {
            productVariationValue.setProductId(Int64(string)!)
        } else if element.isEqualToString("variationID") {
            productVariationValue.setVariationID(Int64(string)!)
        }
        
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqualToString(XmlProductVariationValueParser.TAG_PRODUCT_VARIATION_VALUE) {
            //productVariationValue = ProductVariationValue()
        } else if (elementName as NSString).isEqualToString(XmlProductVariationValueParser.TAG_RESPONSE) {
            handler!(productVariationValue)
        }
    }
    

}