//
//  Extension.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 1/19/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

extension String {
    func htmlDecoded()->String {
        guard (self != "") else { return self }
        
        var newStr = self
        
        let entities = [
            "&quot;"    : "\"",
            "&amp;"     : "&",
            "&apos;"    : "'",
            "&lt;"      : "<",
            "&gt;"      : ">",
        ]
        
        for (name,value) in entities {
            newStr = newStr.stringByReplacingOccurrencesOfString(name, withString: value)
        }
        return newStr
    }
    
    func deleteHTMLTag(tag:String) -> String {
        return self.stringByReplacingOccurrencesOfString("(?i)</?\(tag)\\b[^<]*>", withString: "", options: .RegularExpressionSearch, range: nil)
    }
    
    func deleteHTMLTags(tags:[String]) -> String {
        var mutableString = self
        for tag in tags {
            mutableString = mutableString.deleteHTMLTag(tag)
        }
        return mutableString
    }
}

extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}

