//
//  UserController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/2/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class UserController {
    
    private static let _instance = UserController()
    
    private init(){}
    
    class func sharedInstance() -> UserController {
        return _instance
    }
    
    
    private var user = User()
    
    
    func setUser(user: User) {
        self.user = user
    }
    
    func getUser() -> User {
        return self.user
    }
}
