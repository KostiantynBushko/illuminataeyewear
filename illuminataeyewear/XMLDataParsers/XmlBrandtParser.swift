//
//  ItemProductParser.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 1/22/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation


class XmlBrandParser: NSObject, NSXMLParserDelegate {
    
    var element = NSString()
    var xmlParser = NSXMLParser()
    
    var ID = NSString()
    var categoryID = NSString()
    
    var currentBrandItem = BrandItem()
    var brandItems = [BrandItem]()
    
    var handler: ((brandItems: Array<BrandItem>) -> Void)?
    
    func ParseItems(data: NSData, completeHandler: (brandItems: Array<BrandItem>) -> Void) {
        handler = completeHandler
        xmlParser = NSXMLParser(data: data)
        xmlParser.delegate = self
        xmlParser.parse()
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        element = elementName
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqualToString("response") {
            handler!(brandItems: brandItems)
        } else if (elementName as NSString).isEqualToString("product") {
            currentBrandItem.categoryID.htmlDecoded()
            currentBrandItem.categoryID.htmlDecoded()
            currentBrandItem.manufacturerID.htmlDecoded()
            currentBrandItem.defaultImageID.htmlDecoded()
            currentBrandItem.parentID.htmlDecoded()
            currentBrandItem.shippingClassID.htmlDecoded()
            currentBrandItem.taxClassID.htmlDecoded()
            currentBrandItem.isEnabled.htmlDecoded()
            currentBrandItem.sku.htmlDecoded()
            currentBrandItem.name.htmlDecoded()
            currentBrandItem.shortDescription.htmlDecoded()
            currentBrandItem.longDescription.htmlDecoded()
            currentBrandItem.keywords.htmlDecoded()
            currentBrandItem.pageTitle.htmlDecoded()
            currentBrandItem.dateCreated.htmlDecoded()
            currentBrandItem.dateUpdated.htmlDecoded()
            currentBrandItem.URL.htmlDecoded()
            currentBrandItem.isFeatured.htmlDecoded()
            currentBrandItem.type.htmlDecoded()
            currentBrandItem.ratingSum.htmlDecoded()
            currentBrandItem.ratingCount.htmlDecoded()
            currentBrandItem.rating.htmlDecoded()
            currentBrandItem.reviewCount.htmlDecoded()
            currentBrandItem.minimumQuantity.htmlDecoded()
            currentBrandItem.shippingSurchargeAmount.htmlDecoded()
            currentBrandItem.isSeparateShipment.htmlDecoded()
            currentBrandItem.isFreeShipping.htmlDecoded()
            currentBrandItem.isBackOrderable.htmlDecoded()
            currentBrandItem.isFractionalUnit.htmlDecoded()
            currentBrandItem.isUnlimitedStock.htmlDecoded()
            currentBrandItem.shippingWeight.htmlDecoded()
            currentBrandItem.stockCount.htmlDecoded()
            currentBrandItem.reservedCount.htmlDecoded()
            currentBrandItem.salesRank.htmlDecoded()
            currentBrandItem.fractionalStep.htmlDecoded()
            currentBrandItem.position.htmlDecoded()
            currentBrandItem.categoryIntervalCache.htmlDecoded()
            currentBrandItem.custom.htmlDecoded()
            currentBrandItem.ProductDefaultImage_title.htmlDecoded()
            currentBrandItem.ProductDefaultImage_URL.htmlDecoded()
            currentBrandItem.Manufacturer_name.htmlDecoded()
            currentBrandItem.Category_name.htmlDecoded()
            
            currentBrandItem.defaultImageName = String(currentBrandItem.ID) + "-" + (currentBrandItem.defaultImageID as String) + "-2.jpg"
            brandItems.append(currentBrandItem)
            currentBrandItem = BrandItem()
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if element.isEqualToString("ID") {
            currentBrandItem.ID = Int(string)!
        } else if element.isEqualToString("categoryID") {
            currentBrandItem.categoryID.appendContentsOf(string)
        } else if element.isEqualToString("manufacturerID") {
            currentBrandItem.manufacturerID.appendContentsOf(string)
        } else if element.isEqualToString("defaultImageID") {
            currentBrandItem.defaultImageID.appendContentsOf(string)
        } else if element.isEqualToString("parentID") {
            currentBrandItem.parentID.appendContentsOf(string)
        } else if element.isEqualToString("shippingClassID") {
            currentBrandItem.shippingClassID.appendContentsOf(string)
        } else if element.isEqualToString("taxClassID") {
            currentBrandItem.taxClassID.appendContentsOf(string)
        } else if element.isEqualToString("isEnabled") {
            currentBrandItem.isEnabled.appendContentsOf(string)
        } else if element.isEqualToString("sku") {
            currentBrandItem.sku.appendContentsOf(string)
        } else if element.isEqualToString("name") {
            currentBrandItem.name.appendContentsOf(string)
        } else if element.isEqualToString("shortDescription") {
            currentBrandItem.shortDescription.appendContentsOf(string)
        } else if element.isEqualToString("longDescription") {
            currentBrandItem.longDescription.appendContentsOf(string)
        } else if element.isEqualToString("keywords") {
            currentBrandItem.keywords.appendContentsOf(string)
        } else if element.isEqualToString("pageTitle") {
            currentBrandItem.pageTitle.appendContentsOf(string)
        } else if element.isEqualToString("dateCreated") {
            currentBrandItem.dateCreated.appendContentsOf(string)
        } else if element.isEqualToString("dateUpdated") {
            currentBrandItem.dateUpdated.appendContentsOf(string)
        } else if element.isEqualToString("URL") {
            currentBrandItem.URL.appendContentsOf(string)
        } else if element.isEqualToString("isFeatured") {
            currentBrandItem.isFeatured.appendContentsOf(string)
        } else if element.isEqualToString("type") {
            currentBrandItem.type.appendContentsOf(string)
        } else if element.isEqualToString("ratingSum") {
            currentBrandItem.ratingSum.appendContentsOf(string)
        } else if element.isEqualToString("ratingCount") {
            currentBrandItem.ratingCount.appendContentsOf(string)
        } else if element.isEqualToString("rating") {
            currentBrandItem.rating.appendContentsOf(string)
        } else if element.isEqualToString("reviewCount") {
            currentBrandItem.reviewCount.appendContentsOf(string)
        } else if element.isEqualToString("minimumQuantity") {
            currentBrandItem.minimumQuantity.appendContentsOf(string)
        } else if element.isEqualToString("shippingSurchargeAmount") {
            currentBrandItem.shippingSurchargeAmount.appendContentsOf(string)
        } else if element.isEqualToString("isSeparateShipment") {
            currentBrandItem.isSeparateShipment.appendContentsOf(string)
        } else if element.isEqualToString("isFreeShipping") {
            currentBrandItem.isFreeShipping.appendContentsOf(string)
        } else if element.isEqualToString("isBackOrderable") {
            currentBrandItem.isBackOrderable.appendContentsOf(string)
        } else if element.isEqualToString("isFractionalUnit") {
            currentBrandItem.isFractionalUnit.appendContentsOf(string)
        } else if element.isEqualToString("isUnlimitedStock") {
            currentBrandItem.isUnlimitedStock.appendContentsOf(string)
        } else if element.isEqualToString("shippingWeight") {
            currentBrandItem.shippingWeight.appendContentsOf(string)
        } else if element.isEqualToString("stockCount") {
            currentBrandItem.stockCount.appendContentsOf(string)
        } else if element.isEqualToString("reservedCount") {
            currentBrandItem.reservedCount.appendContentsOf(string)
        } else if element.isEqualToString("salesRank") {
            currentBrandItem.salesRank.appendContentsOf(string)
        } else if element.isEqualToString("fractionalStep") {
            currentBrandItem.fractionalStep.appendContentsOf(string)
        } else if element.isEqualToString("position") {
            currentBrandItem.position.appendContentsOf(string)
        } else if element.isEqualToString("categoryIntervalCache") {
            currentBrandItem.categoryIntervalCache.appendContentsOf(string)
        } else if element.isEqualToString("custom") {
            currentBrandItem.custom.appendContentsOf(string)
        } else if element.isEqualToString("ProductDefaultImage_title") {
            currentBrandItem.ProductDefaultImage_title.appendContentsOf(string)
        } else if element.isEqualToString("ProductDefaultImage_URL") {
            currentBrandItem.ProductDefaultImage_URL.appendContentsOf(string)
        } else if element.isEqualToString("Manufacturer_name") {
            currentBrandItem.Manufacturer_name.appendContentsOf(string)
        } else if element.isEqualToString("Category_name") {
            currentBrandItem.Category_name.appendContentsOf(string)
        }
    }

}














