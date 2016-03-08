//
//  NotificationProtocol.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 3/6/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

protocol NotificationProtocol {
    func parseNotification(notification: String) -> Self
}