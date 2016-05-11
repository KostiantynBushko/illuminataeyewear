//
//  SessionController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/25/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class SessionController {
    
    private var product: Int64?
    private var selectedOption: [Int64:ProductOptionChoice]?
    private var optionText = [Int64:String]()
    
    private var specFields = [Int64: SpecField]()
    
    
    private static var _instance: SessionController?
    private var sessionStatus = false;
    
    class func sharedInstance() -> SessionController {
        if _instance == nil {
            _instance = SessionController()
        }
        return _instance!
    }
    
    
    func SetProduct(product: Int64?) {
        self.product = product
    }
    
    func GetProduct() -> Int64? {
        let p = self.product
        self.product = nil
        return p
    }
    
    func SetOption(option:[Int64:ProductOptionChoice]?) {
        self.selectedOption = option
    }
    
    func GetOption() -> [Int64:ProductOptionChoice]? {
        let option = self.selectedOption
        self.selectedOption = nil
        return option
    }
    
    func SetOptionText(optionText:[Int64:String]!) {
        self.optionText = optionText
    }
    
    func GetOptionText() -> [Int64:String] {
        let optionText = self.optionText
        self.optionText = [Int64:String]()
        return optionText
    }
    
    func GetSpecField(handler:((Dictionary<Int64, SpecField>) -> Void)?, reload: Bool) {
        if self.specFields.count == 0 || reload {
            SpecField().GetSpecFieldList(nil, completeHandler: {(specFields, message, error) in
                if error == nil {
                    for field in specFields {
                        self.specFields[field.ID] = field
                    }
                }
                print("SpecFields count : " + String(self.specFields.count))
                if handler != nil {
                    handler!(self.specFields)
                }
            })
        } else {
            if handler != nil {
                handler!(self.specFields)
            }
        }
    }
}
