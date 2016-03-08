//
//  NotificationViewCell.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 3/6/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class NotificationViewCell: UITableViewCell {

    @IBOutlet var message: UILabel!
    @IBOutlet var url: UILabel!
    @IBOutlet var new: RoundRectLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
