//
//  Brand.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 1/13/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class Brand {
    
    var ID = Int64()
    var parentNodeID = Int64()
    var lft = Int64()
    var rgt = Int64()
    var defaultImageID = Int64()
    var name = String()
    var description = String()
    var keywords = String()
    var pageTitle = String()
    var isEnabled = Bool()
    var availableProductCount = Int64()
    var activeProductCount = Int64()
    var totalProductCount = Int64()
    
    // MARK: Properties
    
    //var brandName : String
    //var categoryId : String
    
    
    // MARK: Initialization
    
    /*init?(brandName: String, categoryId: String) {
        self.brandName = brandName
        self.categoryId = categoryId
        
        if(brandName.isEmpty) {
            return nil
        }
    }*/
    
    static func GetBrands(completeHandler: (Array<Brand>) -> Void) {
        
        let url:NSURL = NSURL(string: Constant.URL_BASE_API)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let paramString = "xml=<category><filter><parentNodeID>107</parentNodeID></filter></category>"
        request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) {(
            let data, let response, let error) in
            
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                print("error ")
                return
            }
            //let dataString = (NSString(data: data!, encoding: NSUTF8StringEncoding) as! String).htmlDecoded()
            //print(dataString)
            XmlBrandParser().Parser(data!, completeHandler: {(brands) in
                completeHandler(brands)
            })
        }
        task.resume()
    }
    
    static func GetBrandByID(ID: Int64, completeHandler: (Brand) -> Void) {
        
        let url:NSURL = NSURL(string: Constant.URL_BASE_API)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let paramString = "xml=<category><filter><ID>" + String(ID) + "</ID></filter></category>"
        request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) {(
            let data, let response, let error) in
            
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                //print("error ")
                return
            }
            //let dataString = (NSString(data: data!, encoding: NSUTF8StringEncoding) as! String).htmlDecoded()
            //print(dataString)
            XmlBrandParser().Parser(data!, completeHandler: {(brands) in
                completeHandler(brands[0])
            })
        }
        task.resume()
    }
}
