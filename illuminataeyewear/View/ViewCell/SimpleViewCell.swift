//
//  SimpleViewCell.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 4/3/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class SimpleViewCell: UITableViewCell {

    @IBOutlet var photo: UIImageView!
    @IBOutlet var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}