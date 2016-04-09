//
//  SessionController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/25/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class SessionController {
    
    private var product: Int64?
    
    private static var _instance: SessionController?
    private var sessionStatus = false;
    
    class func sharedInstance() -> SessionController {
        if _instance == nil {
            _instance = SessionController()
        }
        return _instance!
    }
    
    
    func SetProduct(product: Int64?) {
        self.product = product
    }
    
    func GetProduct() -> Int64? {
        let p = self.product
        self.product = nil
        return p
    }
}
