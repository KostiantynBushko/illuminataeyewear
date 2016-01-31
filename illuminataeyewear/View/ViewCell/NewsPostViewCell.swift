//
//  NewsPostViewCell.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 1/25/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class NewsPostViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var photo: UIImageView!

    @IBOutlet weak var shortDescription: UILabel!
    
    @IBOutlet weak var readMore: UIButton!
    
    @IBOutlet weak var iFrame: UIWebView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
