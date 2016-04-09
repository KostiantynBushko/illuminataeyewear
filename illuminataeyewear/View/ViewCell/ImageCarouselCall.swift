//
//  ImageCarouselCall.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 3/25/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit
import Auk
import moa

class ImageCarouselCall: UITableViewCell {

    @IBOutlet var scrollView: UIScrollView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //scrollView.auk.settings.contentMode = UIViewContentMode.ScaleAspectFill
        scrollView.auk.settings.contentMode = UIViewContentMode.ScaleAspectFit
        //scrollView.auk.settings.contentMode = UIViewContentMode.ScaleToFill
        //scrollView.auk.settings.pageControl.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(1)
        
        if let image = UIImage(named: "ToryBurchBanner.jpg") {
            scrollView.auk.show(image: image)
        }
        
        if let image = UIImage(named: "MainBannerCavalli.jpg") {
            scrollView.auk.show(image: image)
        }
        
        if let image = UIImage(named: "bnr3.jpg") {
            scrollView.auk.show(image: image)
        }
        
        scrollView.auk.startAutoScroll(delaySeconds: 8)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
