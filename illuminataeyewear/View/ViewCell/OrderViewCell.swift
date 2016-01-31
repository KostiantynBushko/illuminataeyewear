//
//  OrderViewCell.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 1/30/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class OrderViewCell: UITableViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var cost: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
