//
//  DBApnToken.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 3/6/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation


class DBApnToken {
    
    static let DB_APN_TOKEN: String = "tb_apn_token"
    
    static func GetToken() -> String? {
        let db = SQLiteDB.sharedInstance()
        let result = db.query("select * from " + DB_APN_TOKEN + " where id = 1" )
        
        var apnToken = [String]()
        
        for row in result {
            //print(String(row["id"]!) + ":" + String(row["token"]!))
            apnToken.append(row["token"]! as! String)
        }
        
        if apnToken.count > 0 {
            return apnToken[0]
        }
        return nil
    }
    
    static func SaveApnToken(token: String) -> Bool {
        let db = SQLiteDB.sharedInstance()
        db.query("insert into " + DB_APN_TOKEN + "('id','token','new')" + " values('1','" + token + "','1')")
        //print(ret)
        //print("DB Save token")
        return true
    }
    
    static func SetSuccessSubmited() {
        let db = SQLiteDB.sharedInstance()
        db.query("insert into " + DB_APN_TOKEN + "('new')" + " values('0')")
        //print("DB Submit token")
        //print(ret)
    }
    
    static func IsSuccessSubmited() -> Bool {
        let db = SQLiteDB.sharedInstance()
        let result = db.query("select * from " + DB_APN_TOKEN + " where id = 1" )
        
        for row in result {
            let new = Int64(String(row["new"]!))!
            if new == 0 {
                print("DB Token is success submited")
                return true
            }
        }
        return false
    }
}
