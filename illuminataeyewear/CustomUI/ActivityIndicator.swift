//
//  ActivityIndicator.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/8/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class ActivityIndicator: UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        self.addSubview(indicator)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
