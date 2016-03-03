//
//  TransactionDetailProductCell.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 3/1/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class TransactionDetailProductCell: UITableViewCell {
    
    @IBOutlet var SKU: UILabel!
    @IBOutlet var name: UILabel!
    @IBOutlet var price: UILabel!
    @IBOutlet var quantity: UILabel!
    @IBOutlet var subtotal: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
