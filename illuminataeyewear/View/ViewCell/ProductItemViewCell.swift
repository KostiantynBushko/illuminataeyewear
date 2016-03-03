//
//  ProductItemViewCell.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/5/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class ProductItemViewCell: UITableViewCell {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var productProperty: UILabel!
    @IBOutlet weak var property: UILabel!
    
    @IBOutlet weak var currency: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        photo.layer.masksToBounds = true
        photo.layer.borderColor = UIColor.lightGrayColor().CGColor
        photo.layer.borderWidth = 0.3
    }
}
