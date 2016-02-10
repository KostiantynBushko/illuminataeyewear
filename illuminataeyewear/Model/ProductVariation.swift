//
//  ProductVariation.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/9/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class ProductVariation {
    
    private var ID = Int64()
    private var typeID = Int64()
    private var name = String()
    private var position = Int64()
    
    func setID(ID: Int64) {
        self.ID = ID
    }
    func setTypeID(typeID: Int64) {
        self.typeID = typeID
    }
    
    func setName(name: String) {
        self.name = name
    }
    
    func setPosition(position: Int64) {
        self.position = position
    }
    
    func getID() -> Int64 {
        return self.ID
    }
    
    func getTypeID() -> Int64 {
        return self.typeID
    }
    
    func getName() -> String {
        return self.name
    }
    
    func getPOsition() -> Int64 {
        return self.position
    }
    
    
    static func GetProductVariationByID(id: Int64, completeHandler: (ProductVariation) -> Void) {
        let url: NSURL = NSURL(string: Constant.URL_BASE_API)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let parameters = "xml=<product_variation><list><ID>" + String(id) + "</ID></list></product_variation>"
        request.HTTPBody = parameters.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request, completionHandler: {(let data, let response, let error) in
            guard let _:NSData = data, let _:NSURLResponse = response where error == nil else {
                return
            }
            XmlProductVariationParser().Parse(data!, completeHandler: {(productVariation) in
                completeHandler(productVariation)
            })
        })
        task.resume()
    }
    

}
