//
//  WishProduct+CoreDataProperties.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 1/21/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension WishProduct {

    @NSManaged var productID: String?
    @NSManaged var productName: String?

}
