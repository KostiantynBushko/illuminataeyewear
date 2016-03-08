//
//  DBNotifications.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 3/6/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class DBNotifications {
    static let DB_NOTIFICATIONS: String = "tb_notifications"
    
    static func GetNotification() -> Array<SimpleNotification> {
        let db = SQLiteDB.sharedInstance()
        let result = db.query("select * from " + DB_NOTIFICATIONS + " ORDER BY ID DESC")
        
        var notifications = [SimpleNotification]()
        
        for row in result {
            //print(String(row["id"]!) + ":" + String(row["payload"]!))
            let notification = SimpleNotification()
            
            notification.ID = Int64(String(row["id"]!))!
            notification.payload = String(row["payload"]!)
            notification.message = String(row["message"]!)
            notification.type = NotificatioinType(rawValue: Int64(String(row["type"]!))!)!
            notification.targetID = Int64(String(row["targetID"]!))!
            notification.url = String(row["url"]!)
            notification.new = Int64(String(row["new"]!)) == 1 ? true : false
            notifications.append(notification)
        }
        
        return notifications
    }
    
    static func SaveNotification(simpleNotification: SimpleNotification) -> Bool {
        let db = SQLiteDB.sharedInstance()
        let payload = "'" + simpleNotification.payload + "'"
        let message = "'" + simpleNotification.message + "'"
        let url = "'" + simpleNotification.url + "'"
        let targetID = "'" + String(simpleNotification.targetID) + "'"
        let type = "'" + (String(simpleNotification.type.rawValue)) + "'"
        
        let values = " values(" + payload + "," + url + "," + targetID + "," + message + "," +  type + ")"
        db.query("insert into " + DB_NOTIFICATIONS + "('payload','url','targetID','message','type')" + values)
        //print(ret)
        return true
    }
    
    static func MarkAsReaded(id: Int64?) {
        if id != nil {
            let db = SQLiteDB.sharedInstance()
            let id = String(id!)
            db.query("update " + DB_NOTIFICATIONS + " set new='0' where id = " + id)
        }
    }
}
