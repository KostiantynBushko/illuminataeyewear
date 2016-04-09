//
//  TermsOfServiceView.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 4/4/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class TermsOfServiceView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSBundle.mainBundle().loadNibNamed("TermsOfServiceView", owner: self, options: nil)
    }

}
