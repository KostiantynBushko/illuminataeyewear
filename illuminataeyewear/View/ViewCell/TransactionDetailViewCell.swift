//
//  TransactionDetailViewCell.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 4/17/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class TransactionDetailViewCell: UITableViewCell {

    @IBOutlet var shippingService: UILabel!
    @IBOutlet var orderTotal: UILabel!
    @IBOutlet var taxes: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
