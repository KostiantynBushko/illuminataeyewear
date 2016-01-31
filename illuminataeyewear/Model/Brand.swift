//
//  Brand.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 1/13/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class Brand {
    
    // MARK: Properties
    
    var brandName : String
    var categoryId : String
    
    
    // MARK: Initialization
    
    init?(brandName: String, categoryId: String) {
        self.brandName = brandName
        self.categoryId = categoryId
        
        if(brandName.isEmpty) {
            return nil
        }
    }
    
}
