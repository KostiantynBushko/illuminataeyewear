//
//  XmlOrderedItemParser.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 4/5/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class XmlOrderedItemParser: NSObject, NSXMLParserDelegate {

    var TAG_RESPONSE = "response"
    var TAG_ORDERED_ITEM = "ordered_item"
    
    var element = NSString()
    var xmlParser: NSXMLParser?
    
    var handler: ((Array<OrderProductItem>, String?, NSError?) -> Void)?
    
    var orderProductItem = OrderProductItem()
    var orderProductItemList = [OrderProductItem]()
    
    func Parse(data: NSData, completeHandler: (Array<OrderProductItem>, String?, NSError?) -> Void) {
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
            self.orderProductItem.ID = Int64(string)!
        } else if element.isEqualToString("productID") {
            self.orderProductItem.productID = Int64(string)!
        } else if element.isEqualToString("customerOrderID") {
            self.orderProductItem.customerOrderID = Int64(string)!
        } else if element.isEqualToString("shipmentID") {
            self.orderProductItem.shipmentID = Int64(string)!
        } else if element.isEqualToString("price") {
            self.orderProductItem.SetPrice(Float32(string)!)
        } else if element.isEqualToString("count") {
            self.orderProductItem.count = Int(string)!
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqualToString(TAG_RESPONSE) {
            handler!(orderProductItemList, nil, nil)
        } else if (elementName as NSString).isEqualToString(TAG_ORDERED_ITEM) {
            self.orderProductItemList.append(orderProductItem)
            self.orderProductItem = OrderProductItem()
        }
    }
    /*<ID>1878</ID>
    <productID>15856</productID>
    <customerOrderID>1687</customerOrderID>
    <shipmentID/><parentID/>
    <price>198</price>
    <count>1</count>
    <reservedProductCount/>
    <dateAdded>2016-04-05 08:40:43</dateAdded>
    <isSavedForLater/>
    <name/>*/
}
