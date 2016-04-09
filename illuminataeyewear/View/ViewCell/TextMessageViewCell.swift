//
//  TextMessageViewCell.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 4/8/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class TextMessageViewCell: UITableViewCell {
    
    @IBOutlet var message: UILabel!
    @IBOutlet var from: UILabel!
    @IBOutlet var time: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
