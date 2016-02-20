//
//  FeatureProductViewCell.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/18/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class FeatureProductViewCell: UITableViewCell {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
