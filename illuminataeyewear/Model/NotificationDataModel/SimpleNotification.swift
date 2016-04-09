//
//  SimpleNotification.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 3/6/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

enum NotificatioinType: Int64 {
    case Unknown, SimpleMessage, Product, Category, News, Coupon, Url, UserMessage
}

class SimpleNotification : BaseNotification, NotificationProtocol {
    
    
    var ID: Int64?
    var type = NotificatioinType.SimpleMessage
    var payload = String()
    var targetID = Int64()
    var url = String()
    var message = String()
    var new: Bool = true
    
    func parseNotification(notification: String) -> Self {
        
        let obj = convertStringToDictionary(notification)
        
        print(obj!["alert"])
        return self
    }
}
