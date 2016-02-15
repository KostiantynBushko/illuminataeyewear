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
    @IBOutlet weak var cost: UILabel!
    @IBOutlet weak var property: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        photo.layer.masksToBounds = true
        photo.layer.borderColor = UIColor.lightGrayColor().CGColor
        photo.layer.borderWidth = 0.3
        // Configure the view for the selected state
    }
}
