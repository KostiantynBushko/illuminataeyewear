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
    
    func getUserFromCurrentSession() -> Bool {
        let user = DBUserTable.GetCurrentUser()
        if (user != nil) {
            UserController.sharedInstance().setUser(user!)
            return true
        }
        return false
    }
    
    func UserLogin(email: String, password: String, completeHandler: (user: User?) -> Void) {
        User.UserLogIn(email, password: password, completeHandler: {(user) in
            if user != nil {
                DBUserTable.SaveUser(user!)
                self.setUser(user!)
            }
            completeHandler(user: user)
        })
    }
    
    func UserLogOut(completeHandler: (Bool) -> Void ) {
        if DBUserTable.removeUser() {
            self.user = nil
            self.isAnonim = true
            completeHandler(true)
        }
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
