//
//  TextFieldRightArrow.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 4/15/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class TextFieldRightArrow: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.rightViewMode = UITextFieldViewMode.Always
        self.rightView = UIImageView(image: UIImage(named: "keyboard_arrow_down_24p"))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.rightViewMode = UITextFieldViewMode.Always
        self.rightView = UIImageView(image: UIImage(named: "keyboard_arrow_down_24p"))
    }
}
