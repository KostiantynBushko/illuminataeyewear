//
//  BaseNotification.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 3/7/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class BaseNotification {
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Error parse string")
            }
        }
        return nil
    }
}
