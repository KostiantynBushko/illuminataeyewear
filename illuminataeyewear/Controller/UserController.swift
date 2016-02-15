//
//  UserController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/2/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class UserController {
    
    private var isAnonim = Bool(true)
    
    private static let _instance = UserController()
    
    private init(){}
    
    class func sharedInstance() -> UserController {
        return _instance
    }
    
    
    private var user: User?
    
    func isAnonimous() -> Bool {
        return isAnonim
    }
    
    func setUser(user: User) {
        isAnonim = false
        self.user = user
    }
    
    func getUser() -> User? {
        if self.user == nil {
            return nil
        }
        return self.user!
    }
}
