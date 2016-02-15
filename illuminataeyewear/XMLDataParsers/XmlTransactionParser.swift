//
//  XmlTransactionParser.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/14/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class XmlTransactionParser: NSObject, NSXMLParserDelegate {
    
    private static var TAG_TRANSACTIONE = "transaction"
    private static var TAG_RESPONSE = "response"
    
    var element = NSString()
    var xmlParser: NSXMLParser?
    var currentTransaction = Transaction()
    var transactions = [Transaction]()
    
    var comment = String()
    var serializedData = String()
    
    var handler: ((Array<Transaction>) -> Void)?
    
    func Parse(data: NSData, completeHandler: (Array<Transaction>) -> Void) {
        handler = completeHandler
        xmlParser = NSXMLParser(data: data)
        xmlParser?.delegate = self
        xmlParser?.parse()
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        element = elementName
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqualToString(XmlTransactionParser.TAG_TRANSACTIONE) {
            
            currentTransaction.comment = self.comment.htmlDecoded()
            currentTransaction.serializedData = self.serializedData.htmlDecoded()
            transactions.append(currentTransaction)
            currentTransaction = Transaction()
            
        } else if (elementName as NSString).isEqualToString(XmlTransactionParser.TAG_RESPONSE) {
            handler!(transactions)
        }
    }
    
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        
        if element.isEqualToString("ID") {
            currentTransaction.ID = Int32(string)!
        } else if element.isEqualToString("parentTransactionID") {
            currentTransaction.parentTransactionID = Int32(string)!
        } else if element.isEqualToString("orderID"){
            currentTransaction.orderID = Int32(string)!
        } else if element.isEqualToString("currencyID") {
            currentTransaction.currencyID = string
        } else if element.isEqualToString("realCurrencyID") {
            currentTransaction.realCurrencyID = string
        } else if element.isEqualToString("userID") {
            currentTransaction.userID = Int32(string)!
        } else if element.isEqualToString("eavObjectID") {
            currentTransaction.eavObjectID = Int32(string)!
        } else if element.isEqualToString("amount") {
            currentTransaction.amount = Float32(string)!
        } else if element.isEqualToString("realAmount") {
            currentTransaction.realAmount = Float32(string)!
        } else if element.isEqualToString("time") {
            currentTransaction.time = string
        } else if element.isEqualToString("method") {
            currentTransaction.method = string
        } else if element.isEqualToString("gatewayTransactionID") {
            currentTransaction.gatewayTransactionID = string
        } else if element.isEqualToString("type") {
            currentTransaction.type = Int(string)!
        } else if element.isEqualToString("methodType") {
            currentTransaction.methodType = Int(string)!
        } else if element.isEqualToString("isCompleted") {
            currentTransaction.isCompleted = Int(string)! == 0 ? false : true
        } else if element.isEqualToString("isVoided") {
            currentTransaction.isVoided = Int(string)! == 0 ? false : true
        } else if element.isEqualToString("ccExpiryYear") {
            currentTransaction.ccExpiryYear = Int(string)!
        } else if element.isEqualToString("ccExpiryMonth") {
            currentTransaction.ccExpiryMonth = Int(string)!
        } else if element.isEqualToString("ccLastDigits") {
            currentTransaction.ccLastDigits = string
        } else if element.isEqualToString("ccType") {
            currentTransaction.ccType = string
        } else if element.isEqualToString("ccName") {
            currentTransaction.ccName = string
        } else if element.isEqualToString("ccCVV") {
            currentTransaction.ccCVV = string
        } else if element.isEqualToString("comment") {
            comment.appendContentsOf(string)
        } else if element.isEqualToString("serializedData") {
            serializedData.appendContentsOf(string)
        }
    }
    
}
