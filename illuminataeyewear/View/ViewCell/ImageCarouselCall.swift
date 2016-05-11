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
    var baners = [Banner]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //scrollView.auk.settings.contentMode = UIViewContentMode.ScaleAspectFill
        scrollView.auk.settings.contentMode = UIViewContentMode.ScaleAspectFit
        //scrollView.auk.settings.contentMode = UIViewContentMode.ScaleToFill
        //scrollView.auk.settings.pageControl.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(1)
        
        /*if let image = UIImage(named: "ToryBurchBanner.jpg") {
            scrollView.auk.show(image: image)
        }
        
        if let image = UIImage(named: "MainBannerCavalli.jpg") {
            scrollView.auk.show(image: image)
        }
        
        if let image = UIImage(named: "bnr3.jpg") {
            scrollView.auk.show(image: image)
        }*/
        
        /*LiveCartController.sharedInstance().getBanners(false, completeHandler: {(banners) in
            for baner in banners {
                let url: String = Constant.URL + baner.file
                print("URL : " + String(url))
                dispatch_async(dispatch_get_main_queue()) {
                    self.scrollView.auk.show(url: url, accessibilityLabel: "Label XXX")
                }
            }
        })*/
        
        scrollView.auk.startAutoScroll(delaySeconds: 8)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    private var updateInProgress: Bool = false
    func Update() {
        if updateInProgress {
            return
        }
        self.updateInProgress = true
        self.scrollView.auk.removeAll()
        
        LiveCartController.sharedInstance().getBanners(false, completeHandler: {(banners) in
            dispatch_async(dispatch_get_main_queue()) {
                for baner in banners {
                    let url: String = Constant.URL + baner.file
                    //print("URL : " + String(url))
                    self.scrollView.auk.show(url: url, accessibilityLabel: "")
                }
                self.updateInProgress = false
            }
        })
    }
    
}
