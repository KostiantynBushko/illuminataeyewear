//
//  ShippingAddressViewController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/4/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class ShippingAddressViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var addressTwoTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var countryStateTextField: UITextField!
    @IBOutlet weak var postalCodeTextField: UITextField!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    let country = ["USA","Canada","Italia","Ukraine"]
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let countryPicker = UIPickerView();
        countryPicker.delegate = self
        countryPicker.dataSource = self
        countryPicker.showsSelectionIndicator = true
        countryTextField.inputView = countryPicker
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.sizeToFit()
        
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("donePicker:"))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([/*cancelButton,*/ spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        countryTextField.inputAccessoryView = toolBar
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
        // Load shipping address
        fillShippingAddressFields()
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            scrollView.frame.size.height -= keyboardSize.height
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            scrollView.frame.size.height += keyboardSize.height
        }
    }

    
    func donePicker(sender: UIBarButtonItem) {
        print("donePikcer")
        countryTextField.resignFirstResponder()
    }
    
    func canclePicker(sender: UIBarButtonItem) {
        print("cancelPikcer")
        countryTextField.resignFirstResponder()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return country.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return country[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        countryTextField.text = country[row]
        pickerView.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Marck
    private func fillShippingAddressFields () {
        // Get shipping address from current order
        let order = OrderController.sharedInstance().getCurrentOrder()
        if order != nil {
            self.nameTextField.text = order?.ShippingAddress_firstName
            self.lastNameTextField.text = order?.ShippingAddress_lastName
            self.companyTextField.text = order?.ShippingAddress_companyName
            self.phoneNumberTextField.text = order?.ShippingAddress_phone
            self.addressTextField.text = order?.ShippingAddress_address1
            self.addressTwoTextField.text = order?.ShippingAddress_address2
            self.cityTextField.text = order?.ShippingAddress_city
            self.countryTextField.text = order?.ShippingAddress_countryName
            self.countryStateTextField.text = order?.ShippingAddress_stateName
            self.postalCodeTextField.text = order?.ShippingAddress_postalCode
        }
    }
    
    

}














