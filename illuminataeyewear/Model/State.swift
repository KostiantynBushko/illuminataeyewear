//
//  State.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/6/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation


class State {
    
    private var ID = Int32()
    private var countryID = String()
    private var code = String()
    private var name = String()
    private var subdivisionType = String()
    
    func setID(ID: Int32) { self.ID = ID }
    func setCountryID(countryID: String) { self.countryID = countryID }
    func setCode(code: String) { self.code = code }
    func setName(name: String) { self.name = name }
    func setSubDivisionType(subdivisionType: String) { self.subdivisionType = subdivisionType }
    
    func getID() -> Int32 { return self.ID }
    func getCountryID() -> String { return self.countryID }
    func getCode() -> String { return self.code }
    func getName() -> String { return self.name }
    func getSubDivisionType() -> String { return self.subdivisionType }
    
    
    static func GetStateByCountryID(countryID: String, completeHandler: (Array<State>) -> Void) {
        let url: NSURL = NSURL(string: Constant.URL_BASE_API)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let parameters = "xml=<state><list><countryID>" + countryID + "</countryID></list></state>"
        request.HTTPBody = parameters.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request, completionHandler: {(let data, let response, let error) in
            guard let _:NSData = data, let _:NSURLResponse = response where error == nil else {
                return
            }
            XmlStateParser().ParseState(data!, completeHandler: {(stateList) in
                completeHandler(stateList)
            })
        })
        task.resume()
    }
}
