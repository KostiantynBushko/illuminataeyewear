//
//  DBWishListTable.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 1/22/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit
import Foundation

class DBWishProductTable {
    
    static let DB_WISH_LIST_TABLE: String = "tb_wish_item"
    
    static func SelectWish() -> Array<WishItem> {
        let db = SQLiteDB.sharedInstance()
        let result = db.query("select * from " + DB_WISH_LIST_TABLE)
        
        var wishArray = [WishItem]()
        
        for row in result {
            print(String(row["id"]!) + ":" + String(row["productId"]!))
            let wishItem = WishItem(productID: Int64(row["productId"]! as! String)!)
            wishArray.append(wishItem!)
        }
        
        return wishArray
    }
    
    static func AddItemToWishList(wishItem: WishItem) -> Bool {
        let db = SQLiteDB.sharedInstance()
        let ret = db.query("insert into " + DB_WISH_LIST_TABLE + "('productId')" + " values('" + String(wishItem.productID) + "')")
        print(ret)
        return true
    }
}
