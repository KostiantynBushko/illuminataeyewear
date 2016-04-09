//
//  AddCouponViewCell.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 3/27/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class AddCouponViewCell: UITableViewCell {
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var addCouponButton: RoundRectButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
