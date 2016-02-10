//
//  XmlCountryParser.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/6/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class XmlCountryParser: NSObject, NSXMLParserDelegate {
    
    private static let TAG_RESPONSE = "response"
    private static let TAG_COUNTRY = "country"
    
    var element = NSString()
    var xmlParser: NSXMLParser?
    
    var currentCountry = Country()
    var countryList = [Country]()
    
    var handler: ((Array<Country>) -> Void)?
    
    func ParseCountry(data: NSData, completeHandler: (Array<Country>) -> Void) {
        handler = completeHandler
        xmlParser = NSXMLParser(data: data)
        xmlParser?.delegate = self
        xmlParser?.parse()
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        element = elementName
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if element.isEqualToString("countryID") {
            currentCountry.setCountryID(string)
        } else if element.isEqualToString("country_name") {
            currentCountry.setCountry(string)
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqualToString(XmlCountryParser.TAG_COUNTRY) {
            countryList.append(currentCountry)
            currentCountry = Country()
        } else if (elementName as NSString).isEqualToString(XmlCountryParser.TAG_RESPONSE) {
            handler!(countryList)
        }
    }
    
}
