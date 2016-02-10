//
//  LiveCartController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/6/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class LiveCartController {
    
    private static var _instance: LiveCartController?
    private init() {}
    
    private var countryList = [Country]()
    
    class func sharedInstance() -> LiveCartController {
        if _instance == nil {
            _instance = LiveCartController()
            _instance?.initController()
        }
        return _instance!
    }
    
    private func initController () {
        Country.GetCountryList({(countryList) in
            self.countryList = countryList
        })
    }
    
    func getCountries() -> Array<Country> {
        return self.countryList
    }
}
