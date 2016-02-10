//
//  XmlUserAdddressParser.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/6/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class XmlUserAddressParser: NSObject, NSXMLParserDelegate {
    
    let TAG_RESPONSE = "response"
    let TAG_USER_ADDRESS = "user_address"
    
    var element = NSString()
    var xmlParser: NSXMLParser?
    
    var userAddress = UserAddress()
    
    var firstName = String()
    var lastName = String()
    var companyName = String()
    var address1 = String()
    var address2 = String()
    var city = String()
    var country = String()
    var stateName = String()
    var postalCode = String()
    var phone = String()
    
    var handler: ((UserAddress) -> Void)?
    
    func ParseUserAddress(data: NSData, completeHandler: (userAddress: UserAddress) -> Void) {
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
            self.userAddress.setID(Int32(string)!)
        }
        else if element.isEqualToString("stateID") {
            self.userAddress.setStateID(Int32(string)!)
        }
        else if element.isEqualToString("eavObjectID") {
            
        }
        else if element.isEqualToString("firstName") {
            self.firstName.appendContentsOf(string)
        }
        else if element.isEqualToString("lastName") {
            self.lastName.appendContentsOf(string)
        }
        else if element.isEqualToString("companyName") {
            self.companyName.appendContentsOf(string)
        }
        else if element.isEqualToString("address1") {
            self.address1.appendContentsOf(string)
        }
        else if element.isEqualToString("address2") {
            self.address2.appendContentsOf(string)
        }
        else if element.isEqualToString("city") {
            self.city.appendContentsOf(string)
        }
        else if element.isEqualToString("stateName") {
            self.stateName.appendContentsOf(string)
        }
        else if element.isEqualToString("postalCode") {
            self.postalCode.appendContentsOf(string)
        }
        else if element.isEqualToString("countryID") {
            self.userAddress.setCountryID(string)
        }
        else if element.isEqualToString("phone") {
            self.phone.appendContentsOf(string)
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqualToString(TAG_RESPONSE) {
            handler!(self.userAddress)
            
        } else if (elementName as NSString).isEqualToString(TAG_USER_ADDRESS) {
            self.userAddress.setFirstName(self.firstName.htmlDecoded())
            self.userAddress.setLastName(self.lastName.htmlDecoded())
            self.userAddress.setCompanyName(self.companyName.htmlDecoded())
            self.userAddress.setAddress(self.address1.htmlDecoded())
            self.userAddress.setAddressTwo(self.address2.htmlDecoded())
            self.userAddress.setCity(self.city.htmlDecoded())
            self.userAddress.setStateName(self.stateName.htmlDecoded())
            self.userAddress.setPostalCode(self.postalCode.htmlDecoded())
            self.userAddress.setPhone(self.phone.htmlDecoded())
        
            self.firstName = String()
            self.lastName = String()
            self.companyName = String()
            self.address1 = String()
            self.address2 = String()
            self.city = String()
            self.stateName = String()
            self.postalCode = String()
            self.phone = String()
        }
    }
    
}

















