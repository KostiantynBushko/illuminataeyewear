//
//  ShippingMethodViewController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/19/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class ShippingMethodViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var shippingMethod: UITextField!
    
    let shippingMethodPicker = UIPickerView();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(title: "Next", style: .Plain, target: self, action: "nextAction:"), animated: true)
        self.title = "Method"
        
        shippingMethod.inputView = shippingMethodPicker
        shippingMethod.inputAccessoryView = toolBarButtonDone(0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    func nextAction(selector: AnyObject) {
        let checkoutViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CheckoutViewController") as! CheckoutViewController
        self.navigationController?.pushViewController(checkoutViewController, animated: true)
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return nil
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.resignFirstResponder()
    }
    
    
    func donePicker(sender: UIBarButtonItem) {
        shippingMethod.resignFirstResponder()
    }
    
    private func toolBarButtonDone(tag: Int) -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("donePicker:"))
        doneButton.tag = tag
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        return toolBar
    }
}
