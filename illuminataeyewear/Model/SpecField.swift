//
//  SpecField.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 4/14/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class SpecField: BaseModel {
    
    var ID = Int64()
    var specFieldGroupID = Int64()
    var name = String()
    var description = String()
    var type = Int64()
    var dataType = Int64()
    var position = Int64()
    var handle = String()
    var isMultiValue = Bool()
    var isRequired = Bool()
    var isDisplayed = Bool()
    var isDisplayedInList = Bool()
    var valuePrefix = String()
    var valueSuffix = String()
    var categoryID = Int64()
    var isSortable = Bool()
    
    func GetSpecFieldList(ID: Int64?, completeHandler: (Array<SpecField>, String?, NSError?) -> Void) {
        var paramString = "xml=<spec_field><list>"
        if ID != nil {
            paramString += "<ID>" + String(ID!) + "</ID>"
        }
        paramString += "</list></spec_field>"
        
        let url = NSURL(string: Constant.URL_BASE_API)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request){ (let data, let response, let error) in
            guard let _:NSData = data, let _:NSURLResponse = response where error == nil else {
                return
            }
            //let dataString = (NSString(data: data!, encoding: NSUTF8StringEncoding) as! String).htmlDecoded()
            //print("SpecField : " + dataString)
            
            XmlSpecFieldParser().Parse(data!, completeHandler: {(specFields, message, error)in
                completeHandler(specFields, message, error)
            })
        }
        task.resume()
    }
}
