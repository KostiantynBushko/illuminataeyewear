//
//  WishItem.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 1/22/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class WishItem {
    static let PRODUCT_ID: String = "ID"
    
    var productID: String?
    
    init?(productID: String) {
        self.productID = productID
    }
}