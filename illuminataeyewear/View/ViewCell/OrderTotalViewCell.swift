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
    
    @IBOutlet weak var currency_1: UILabel!
    @IBOutlet weak var currency_2: UILabel!
    @IBOutlet weak var currency_3: UILabel!
    @IBOutlet weak var currency_4: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCurrency(currency: String) {
        self.currency_1.text = currency
        self.currency_2.text = currency
        self.currency_3.text = currency
        self.currency_4.text = currency
    }
}
