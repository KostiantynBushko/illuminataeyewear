//
//  XmlBannerParser.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 4/22/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class XmlBannerParser: NSObject, NSXMLParserDelegate {
    
    var TAG_RESPONSE = "response"
    var TAG_BANNER = "banner"
    
    
    var element = NSString()
    var xmlParser: NSXMLParser?
    
    var handler: ((Array<Banner>, String?, NSError?) -> Void)?
    
    private var error: NSError?
    private var message: String?
    
    
    private var file = String()
    
    private var banner = Banner()
    private var banners = [Banner]()
    
    
    func Parse(data: NSData, completeHandler: (Array<Banner>, String?, NSError?) -> Void) {
        handler = completeHandler
        xmlParser = NSXMLParser(data: data)
        xmlParser?.delegate = self
        xmlParser?.parse()
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        self.element = elementName
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if element.isEqualToString("ID") {
            self.banner.ID = Int64(string)!
        } else if element.isEqualToString("order") {
            self.banner.order = Int64(string)!
        } else if element.isEqualToString("file") {
            self.file.appendContentsOf(string.htmlDecoded())
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
            if handler != nil {
                handler?(self.banners, message, error)
            }
        } else if (elementName as NSString).isEqualToString(TAG_BANNER) {
            self.banner.file = self.file.htmlDecoded()
            self.banners.append(self.banner)
            self.file = String()
            self.banner = Banner()
        }
    }
}
