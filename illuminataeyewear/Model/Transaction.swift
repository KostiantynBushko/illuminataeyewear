//
//  Transaction.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/14/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation


class Transaction: BaseModel {

    var ID = Int32()
    var parentTransactionID = Int32()
    var orderID = Int32()
    var currencyID = String()
    var realCurrencyID = String()
    var userID = Int32()
    var eavObjectID = Int32()
    var amount = Float32()
    var realAmount = Float32()
    var time = String()
    var method = String()
    var gatewayTransactionID = String()
    var type = Int()
    var methodType = Int()
    var isCompleted = Bool(false)
    var isVoided = Bool(false)
    var ccExpiryYear = Int()
    var ccExpiryMonth = Int()
    var ccLastDigits = String()
    var ccType = String()
    var ccName = String()
    var ccCVV = String()
    var comment = String()
    var serializedData = String()
    
    override func getXML(id: Int32) -> String {
        return ""
    }
    
    static func GetTransactionByOrderID(ID: Int64, completeHandler: (Array<Transaction>) -> Void) {
        let url: NSURL = NSURL(string: Constant.URL_BASE_API)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let parameters = "xml=<transaction><list><orderID>" + String(ID) + "</orderID></list></transaction>"
        request.HTTPBody = parameters.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request, completionHandler: {(let data, let response, let error) in
            guard let _:NSData = data, let _:NSURLResponse = response where error == nil else {
                return
            }
            
            let dataString = (NSString(data: data!, encoding: NSUTF8StringEncoding) as! String).htmlDecoded()
            print("Transactions : " + String(dataString))
            XmlTransactionParser().Parse(data!, completeHandler: {(transactions) in
                completeHandler(transactions)
            })
        })
        task.resume()
    }
    
    static func MakeTransaction(orderID: Int64, currencyID: String, amount: String, gatewayTransactionID: String, completeHandler: (Array<Transaction>) -> Void) {
        print(gatewayTransactionID)
        print(currencyID)
        print(amount)
        let url: NSURL = NSURL(string: Constant.URL_BASE_API)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let parameters = "xml=<transaction><create>"
            + "<orderID>" + String(orderID) + "</orderID>"
            + "<currencyID>" + String(currencyID) + "</currencyID>"
            + "<method>PaypalWebsitePaymentsStandard</method>"
            + "<amount>" + String(amount) + "</amount>"
            + "<gatewayTransactionID>" + gatewayTransactionID + "</gatewayTransactionID>"
            +  "</create></transaction>"
        
        request.HTTPBody = parameters.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request, completionHandler: {(let data, let response, let error) in
            guard let _:NSData = data, let _:NSURLResponse = response where error == nil else {
                return
            }
            
            let dataString = (NSString(data: data!, encoding: NSUTF8StringEncoding) as! String).htmlDecoded()
            print("Make Transactions : " + String(dataString))
            print("------------------------------------------------------------------------------------")
            XmlTransactionParser().Parse(data!, completeHandler: {(transactions) in
                completeHandler(transactions)
            })
        })
        task.resume()
    }
}
 