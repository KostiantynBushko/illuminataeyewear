//
//  XmlBrandParser.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 3/8/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class XmlBrandParser: NSObject, NSXMLParserDelegate {

    var TAG_CATEGORY = "category"
    var TAG_RESPONSE = "response"
    
    var xmlParser: NSXMLParser?
    var element = NSString()
    var currentBrand = Brand()
    var brands = [Brand]()
    
    var name = String()
    var brand_description = String()
    var keywords = String()
    var pageTitle = String()
    
    var handler: ((Array<Brand>) -> Void)?
    
    func Parser(data: NSData, completeHandler: (Array<Brand>) -> Void) {
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
            currentBrand.ID = Int64(string)!
        } else if element.isEqualToString("parentNodeID") {
            currentBrand.parentNodeID = Int64(string)!
        } else if element.isEqualToString("lft") {
            currentBrand.lft = Int64(string)!
        } else if element.isEqualToString("rgt") {
            currentBrand.rgt = Int64(string)!
        } else if element.isEqualToString("defaultImageID") {
            currentBrand.defaultImageID = Int64(string)!
        } else if element.isEqualToString("name") {
            self.name.appendContentsOf(string)
        } else if element.isEqualToString("description") {
            self.brand_description.appendContentsOf(string)
        } else if element.isEqualToString("keywords") {
            self.keywords.appendContentsOf(string)
        } else if element.isEqualToString("pageTitle") {
            self.pageTitle.appendContentsOf(string)
        } else if element.isEqualToString("isEnabled") {
            currentBrand.isEnabled = Int64(string) == 1 ? true : false
        } else if element.isEqualToString("availableProductCount") {
            currentBrand.availableProductCount = Int64(string)!
        } else if element.isEqualToString("activeProductCount") {
            currentBrand.activeProductCount = Int64(string)!
        } else if element.isEqualToString("totalProductCount") {
            currentBrand.totalProductCount = Int64(string)!
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqualToString(TAG_RESPONSE) {
            if handler != nil {
                handler?(self.brands)
            }
        } else if (elementName as NSString).isEqualToString(TAG_CATEGORY) {
            currentBrand.name = self.name.htmlDecoded()
            currentBrand.description = self.brand_description.htmlDecoded()
            currentBrand.keywords = self.keywords.htmlDecoded()
            currentBrand.pageTitle = self.pageTitle.htmlDecoded()
            self.brands.append(currentBrand)
            currentBrand = Brand()
            self.name = String()
            self.brand_description = String()
            self.keywords = String()
            self.pageTitle = String()
        }
    }
}
