//
//  TransactionViewCell.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/18/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class TransactionViewCell: UITableViewCell {


    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var order_id: UILabel!
    @IBOutlet weak var recipient: UILabel!
    @IBOutlet weak var total: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
