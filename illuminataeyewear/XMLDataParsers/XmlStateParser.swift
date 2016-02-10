//
//  XmlStateParser.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/6/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class XmlStateParser: NSObject, NSXMLParserDelegate {

    static let TAG_RESPONSE = "response"
    static let TAG_STATE = "state"
    
    var currentState = State()
    var stateList = [State]()
    
    var currentName = String()
    
    var element = NSString()
    var xmlParser: NSXMLParser?
    
    var handler: ((Array<State>) -> Void)?
    
    func ParseState(data: NSData, completeHandler: (Array<State>) -> Void) {
        handler = completeHandler
        xmlParser = NSXMLParser(data: data)
        xmlParser!.delegate = self
        xmlParser!.parse()
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        element = elementName
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if element.isEqualToString("ID") {
            currentState.setID(Int32(string)!)
        } else if element.isEqualToString("countryID") {
            currentState.setCountryID(string)
        } else if element.isEqualToString("code") {
            currentState.setCode(string)
        } else if element.isEqualToString("name") {
            currentName.appendContentsOf(string)
        } else if element.isEqualToString("subdivisionType") {
            currentState.setSubDivisionType(string)
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqualToString(XmlStateParser.TAG_STATE) {
            stateList.append(currentState)
            currentState.setName(currentName.htmlDecoded())
            currentName = String()
            currentState = State()
        } else if (elementName as NSString).isEqualToString(XmlStateParser.TAG_RESPONSE) {
            handler!(stateList)
        }
    }

}
