//
//  WishProduct.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 1/21/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit
import Foundation
import CoreData


class WishProduct: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    
    static func addProductToWishList(productID: String, productName: String) {
        let managedObjectController = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let entity = NSEntityDescription.insertNewObjectForEntityForName("WishProduct", inManagedObjectContext: managedObjectController) as! WishProduct
        
        entity.setValue(productID, forKey: "productID")
        entity.setValue(productName, forKey: "productName")
        
        do{
            try managedObjectController.save()
        } catch {
            fatalError("failure to save context: \(error)")
        }
    }
    
    static func getWishList() -> Array<WishProduct> {
        let managedObjectController = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let wishProduct = NSFetchRequest(entityName: "WishProduct")
        
        let wishProductList: [WishProduct]
        do {
            wishProductList = try managedObjectController.executeFetchRequest(wishProduct) as! [WishProduct]
            print(wishProductList)
        } catch {
            fatalError("problem fetching Wish Product list: \(error)")
        }
    
        return wishProductList
    }
}
