//
//  DBUserTable.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/2/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class DBUserTable {
    
    static let DB_USER_TABLE: String = "tb_user"
    
    static func GetCurrentUser() -> User? {
        let db = SQLiteDB.sharedInstance()
        let result = db.query("select * from " + DB_USER_TABLE + " where id = 1")
        
        var user: User?
        
        for row in result {
            //print(String(row["id"]!) + ":" + String(row["email"]!) + ":" + String(row["userID"]))
            user = User()
            user?.ID = Int64(String(row["userID"]!))!
            user?.defaultBillingAddressID = Int64(String(row["defaultBillingAddressID"]!))!
            user?.defaultShippingAddressID = Int64(String(row["defaultShippingAddressID"]!))!
            user?.userGroupID = Int64(String(row["userGroupID"]!))!
            user?.eavObjectID = Int64(String(row["eavObjectID"]!))!
            user?.locale = String(row["locale"]!)
            user?.email = String(row["email"]!)
            user?.companyName = String(row["companyName"]!)
            user?.dateCreated = String(row["dateCreated"]!)
            user?.firstName = String(row["firstName"]!)
            user?.lastName = String(row["lastName"]!)
            let enabled = Int(String(row["isEnabled"]!))!
            let isEnabled = enabled == 1 ? true : false
            user?.isEnabled = isEnabled
        }
        
        return user
    }
    
    static func SaveUser(user: User) -> Bool {
        let db = SQLiteDB.sharedInstance()
        let isEnabled = user.isEnabled ? "1" : "0"
        
        let values = "('1'"
            + ","
            + "'" + String(user.ID) + "'"
            + ","
            + "'" + String(user.defaultShippingAddressID) + "'"
            + ","
            + "'" + String(user.defaultBillingAddressID) + "'"
            + ","
            + "'" + String(user.userGroupID) + "'"
            + ","
            + "'" + String(user.eavObjectID) + "'"
            + ","
            + "'" + user.locale + "'"
            + ","
            + "'" + user.email + "'"
            + ","
            + "'" + user.firstName + "'"
            + ","
            + "'" + user.lastName + "'"
            + ","
            + "'" + user.companyName + "'"
            + ","
            + "'" + user.dateCreated + "'"
            + ","
            + "'" + isEnabled + "'" + ");";
        
        let ret = db.query("insert or replace into "
            + DB_USER_TABLE
            + "('id', 'userID','defaultShippingAddressID','defaultBillingAddressID','userGroupID','eavObjectID','locale','email','firstName','lastName','companyName','dateCreated','isEnabled')"
            + " values" + values)
        print(ret)
        return true
    }
    
    static func removeUser() -> Bool {
        let db = SQLiteDB.sharedInstance()
        let _ = db.query("delete from " + DB_USER_TABLE + " where ID = 1")
        return true
    }
}