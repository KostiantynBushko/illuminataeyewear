//
//  RoundRectLabel.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/14/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class RoundRectLabel: UILabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 8.0;
    }
    
}
