//
//  OrderTotalViewCell.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/5/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class OrderTotalViewCell: UITableViewCell {
    
    @IBOutlet weak var subTotalBeforeTax: UILabel!
    @IBOutlet weak var shippingPickUp: UILabel!
    @IBOutlet weak var HST: UILabel!
    @IBOutlet weak var orderTotal: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
