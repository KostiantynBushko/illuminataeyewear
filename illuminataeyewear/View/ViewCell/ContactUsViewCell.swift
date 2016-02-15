//
//  ContactUsViewCell.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/12/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit
import MessageUI

class ContactUsViewCell: UITableViewCell {
    

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userMessage: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userMessage.layer.borderColor = UIColor.lightGrayColor().CGColor
        userMessage.layer.borderWidth = 0.5
        userMessage.layer.cornerRadius = 5
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
