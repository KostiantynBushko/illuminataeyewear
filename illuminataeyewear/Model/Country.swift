//
//  Country.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/6/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class Country {
    
    private var countryID = String()
    private var country = String()

    func setCountryID(countryID: String) {
        self.countryID = countryID
    }
    
    func setCountry(country: String) {
        self.country = country
    }
    
    func getCountryID() -> String {
        return self.countryID
    }
    
    func getCountry() -> String {
        return self.country
    }
    
    static func GetCountryList(completeHandler: (Array<Country>) -> Void) {
        let url:NSURL = NSURL(string: Constant.URL_BASE_API)!
        let session = NSURLSession.sharedSession()
    
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let parameters = "xml=<country><list></list></country>"
        request.HTTPBody = parameters.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request, completionHandler: {(let data, let response, let error) in
            guard let _:NSData = data, let _:NSURLResponse = response where error == nil else {
                return
            }
            XmlCountryParser().ParseCountry(data!, completeHandler:{(countryList) in
                completeHandler(countryList)
            })
        })
        task.resume()
    }

}
