//
//  SessionController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/25/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class SessionController {
    
    private static var _instance: SessionController?
    private var sessionStatus = false;
    
    class func sharedInstance() -> SessionController {
        if _instance == nil {
            _instance = SessionController()
        }
        return _instance!
    }
}
