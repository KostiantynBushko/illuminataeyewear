//
//  ItemPriceParser.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 1/19/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class XmlPriceParser: NSObject, NSXMLParserDelegate {
    
    var element = NSString()
    var xmlParser = NSXMLParser()
    
    var sku: String = ""
    var definePrices: String = ""
    var defineListPrice: String = ""
    var quantityPrices: String = ""
    
    var priceHadElement = ""
    
    var priceItem = PriceItem()
    
    var handler: ((priceItem: PriceItem) -> Void)?
    
    func ParceItem(data: NSData, completeHandler: (priceItem: PriceItem) -> Void) {
        handler = completeHandler
        xmlParser = NSXMLParser(data: data)
        xmlParser.delegate = self
        xmlParser.parse()
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        element = elementName
        if element.isEqualToString("definedListPrices") {
            self.priceHadElement = elementName
        }else if element.isEqualToString("definedPrices") {
            self.priceHadElement = elementName
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if (element as NSString).isEqualToString("response") {
            
        } else if element.isEqualToString("sku") {
            self.sku += string
        } else if element.isEqualToString("CAD") {
            if (priceHadElement as NSString).isEqualToString("definedPrices") {
                self.definePrices += string
            } else if (priceHadElement as NSString).isEqualToString("definedListPrices") {
                self.defineListPrice += string
            }
        }else if element.isEqualToString("quantityPrices") {
            self.quantityPrices += string
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if (elementName as NSString).isEqualToString("response") {
            priceItem.sku = self.sku
            priceItem.definePrices = self.definePrices
            priceItem.defineListPrice = self.defineListPrice
            priceItem.quantityPrices = self.quantityPrices
            
            handler!(priceItem: priceItem)
            self.sku = ""
            self.definePrices = ""
            self.defineListPrice = ""
            
        }
    }
    
}
