//
//  ShippingAddressViewController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/4/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class ShippingAddressViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, BusyAlertDelegate {
    
    @IBOutlet weak var billingSwitch: UISwitch!
    // Shipping address

    @IBOutlet weak var shippingNameTextField: UITextField!
    @IBOutlet weak var shippingLastNameTextField: UITextField!
    @IBOutlet weak var shippingCompanyNameTextField: UITextField!
    @IBOutlet weak var shippingPhoneNumberTextField: UITextField!
    @IBOutlet weak var shippingAddressTextField: UITextField!
    @IBOutlet weak var shippingAddressTwoTextField: UITextField!
    @IBOutlet weak var shippingCityTextField: UITextField!
    @IBOutlet weak var shippingCountryTextField: UITextField!
    @IBOutlet weak var shippingStateTextField: UITextField!
    @IBOutlet weak var shippingPostalCodeTextField: UITextField!
    
    // Billing address
    @IBOutlet weak var billingNameTextField: UITextField!
    @IBOutlet weak var billingLasNameTextField: UITextField!
    @IBOutlet weak var billingCompanyNameTextField: UITextField!
    @IBOutlet weak var billingPhoneNumberTextField: UITextField!
    @IBOutlet weak var billingAddressTextField: UITextField!
    @IBOutlet weak var billingAddressTwoTextField: UITextField!
    @IBOutlet weak var billingCityTextField: UITextField!
    @IBOutlet weak var billingCountryTextField: UITextField!
    @IBOutlet weak var billingStateTextField: UITextField!
    @IBOutlet weak var billingPostalCodeTextField: UITextField!
    
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!

    let order = OrderController.sharedInstance().getCurrentOrder()
    
    let shippingCountry = LiveCartController.sharedInstance().getCountries()
    var billingCountry = LiveCartController.sharedInstance().getCountries()
    var shippingStateList = Dictionary<String, Array<State>>()
    var billingStateList = Dictionary<String, Array<State>>()
    
    var currentShippingCountry = Country()
    var currentBillingCountry = Country()
    var currentShippingState = State()
    var currentBillingState = State()

    let TAG_SHIPPING_COUNTRY_PICKER = 0
    let TAG_SHIPPING_STATE_PICKER = 1
    let TAG_BILLING_COUNTRY_PICKER = 2
    let TAG_BILLING_STATE_PICKER = 3
    
    let shippingCountryPicker = UIPickerView();
    let billingCountryPicker = UIPickerView()
    let shippingStatePicker = UIPickerView()
    let billingStatePicker = UIPickerView()
    
    var busyAlertController: BusyAlert?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialise Picker View
        shippingCountryPicker.delegate = self
        shippingCountryPicker.dataSource = self
        shippingCountryPicker.showsSelectionIndicator = true
        shippingCountryPicker.tag = TAG_SHIPPING_COUNTRY_PICKER
        shippingCountryTextField.inputView = shippingCountryPicker

        billingCountryPicker.delegate = self
        billingCountryPicker.dataSource = self
        billingCountryPicker.showsSelectionIndicator = true
        billingCountryPicker.tag = TAG_BILLING_COUNTRY_PICKER
        billingCountryTextField.inputView = billingCountryPicker
        
        shippingStatePicker.delegate = self
        shippingStatePicker.dataSource = self
        shippingStatePicker.showsSelectionIndicator = true
        shippingStatePicker.tag = TAG_SHIPPING_STATE_PICKER
        shippingStateTextField.inputView = shippingStatePicker
        
        billingStatePicker.delegate = self
        billingStatePicker.dataSource = self
        billingStatePicker.showsSelectionIndicator = true
        billingStatePicker.tag = TAG_BILLING_STATE_PICKER
        billingStateTextField.inputView = billingStatePicker
        
        // Set default country for billing and shipping address
        currentShippingCountry = LiveCartController.sharedInstance().getCountryCodeByName((order?.ShippingAddress_countryName)!)
        currentBillingCountry = LiveCartController.sharedInstance().getCountryCodeByName((order?.BillingAddress_countryName)!)
        
        //currentShippingState = State()
        //currentBillingState = State()
        
        shippingCountryTextField.inputAccessoryView = toolBarButtonDone(TAG_SHIPPING_COUNTRY_PICKER)
        billingCountryTextField.inputAccessoryView = toolBarButtonDone(TAG_BILLING_COUNTRY_PICKER)
        shippingStateTextField.inputAccessoryView = toolBarButtonDone(TAG_SHIPPING_STATE_PICKER)
        billingStateTextField.inputAccessoryView = toolBarButtonDone(TAG_BILLING_STATE_PICKER)
        
        
        // Get country state
        initStateForCurrentShippingCountry((currentShippingCountry.getCountryID()))
        initStateForCurrentBillingCountry((currentBillingCountry.getCountryID()))
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
    
        // Fill shipping and billing address field's
        var needUpdateOrder = false
        if OrderController.sharedInstance().getCurrentOrder()?.shippingAddressID == 0 {
           OrderController.sharedInstance().getCurrentOrder()?.shippingAddressID = (UserController.sharedInstance().getUser()?.defaultShippingAddressID)!
            needUpdateOrder = true
        }
        if OrderController.sharedInstance().getCurrentOrder()?.billingAddressID == 0 {
            OrderController.sharedInstance().getCurrentOrder()?.billingAddressID = (UserController.sharedInstance().getUser()?.defaultBillingAddressID)!
            needUpdateOrder = true
        }
        
        if needUpdateOrder {
            OrderController.sharedInstance().UpdateUserOrder((UserController.sharedInstance().getUser()?.ID)!, completeHandler: {(success) in
                dispatch_async(dispatch_get_main_queue()) {
                    self.fillShippingAddressFields()
                    self.fillBillingAddressFields()
                }
            })
        } else {
            fillShippingAddressFields()
            fillBillingAddressFields()
        }
        
        billingSwitch.setOn(true, animated: false)
        setEnableBillingTexTField(!(billingSwitch.on))
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        busyAlertController = BusyAlert(title: "", message: "", presentingViewController: self)
        busyAlertController?.delegate = self
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

    
    @IBAction func swichBillingAddress(sender: AnyObject) {
        if (sender as! UISwitch).on {
            setEnableBillingTexTField(false)
        } else {
            setEnableBillingTexTField(true)
        }
    }
    
    func donePicker(sender: UIBarButtonItem) {
        if sender.tag == TAG_SHIPPING_COUNTRY_PICKER {
            if (shippingStateList[(currentShippingCountry.getCountryID())] == nil) {
                initStateForCurrentShippingCountry((currentShippingCountry.getCountryID()))
            }
            shippingStateTextField.inputView = shippingStatePicker
            shippingCountryTextField.resignFirstResponder()
        } else if sender.tag == TAG_BILLING_COUNTRY_PICKER {
            if (billingStateList[(currentBillingCountry.getCountryID())] == nil) {
                initStateForCurrentBillingCountry((currentBillingCountry.getCountryID()))
            }
            
            billingStateTextField.inputView = billingStatePicker
            billingCountryTextField.resignFirstResponder()
        } else if sender.tag == TAG_SHIPPING_STATE_PICKER {
            shippingStateTextField.resignFirstResponder()
        } else if sender.tag == TAG_BILLING_STATE_PICKER {
            billingStateTextField.resignFirstResponder()
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == TAG_SHIPPING_COUNTRY_PICKER {
            return shippingCountry.count
        } else if pickerView.tag == TAG_BILLING_COUNTRY_PICKER {
            return billingCountry.count
        } else if pickerView.tag == TAG_SHIPPING_STATE_PICKER {
            if shippingStateList[(currentShippingCountry.getCountryID())] != nil {
                return (shippingStateList[(currentShippingCountry.getCountryID())]!.count)
            }
            return 0
        } else if pickerView.tag == TAG_BILLING_STATE_PICKER {
            if billingStateList[(currentBillingCountry.getCountryID())] != nil {
                return (billingStateList[(currentBillingCountry.getCountryID())]!.count)
            }
            return 0
        }
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == TAG_SHIPPING_COUNTRY_PICKER {
            return shippingCountry[row].getCountry()
        }
        else if pickerView.tag == TAG_BILLING_COUNTRY_PICKER {
            return billingCountry[row].getCountry()
        }
        else if pickerView.tag == TAG_SHIPPING_STATE_PICKER {
            if var states = shippingStateList[(currentShippingCountry.getCountryID())] {
                return states[row].getName()
            } else {
                return nil
            }
        } else if pickerView.tag == TAG_BILLING_STATE_PICKER {
            if var states = billingStateList[(currentBillingCountry.getCountryID())] {
                return states[row].getName()
            } else {
                return nil
            }
        }
        return nil
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == TAG_SHIPPING_COUNTRY_PICKER {
            shippingCountryTextField.text = shippingCountry[row].getCountry()
            currentShippingCountry = shippingCountry[row]
        }
        else if pickerView.tag == TAG_BILLING_COUNTRY_PICKER {
            billingCountryTextField.text = billingCountry[row].getCountry()
            currentBillingCountry = billingCountry[row]
        }
        else if pickerView.tag == TAG_SHIPPING_STATE_PICKER {
            if var states = shippingStateList[(currentShippingCountry.getCountryID())] {
                shippingStateTextField.text = states[row].getName()
            }
        }
        else if pickerView.tag == TAG_BILLING_STATE_PICKER {
            if var states = billingStateList[(currentBillingCountry.getCountryID())] {
                billingStateTextField.text = states[row].getName()
            }
        }
        pickerView.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func initStateForCurrentShippingCountry(countryID: String) {
        State.GetStateByCountryID(countryID, completeHandler: {(stateList) in
            if stateList.count > 0 {
                self.shippingStateList[countryID] = stateList
                dispatch_async(dispatch_get_main_queue()) {
                    self.shippingStateTextField.text = stateList[0].getName()
                    self.currentShippingState = stateList[0]
                    /*if ((self.shippingStateTextField.text?.isEmpty) != nil) {
                        let state = self.getStateByName(self.shippingStateTextField.text!)
                        if state.getID() > 0 {
                            self.currentShippingState = state
                        }
                    } else {
                        self.shippingStateTextField.text = stateList[0].getName()
                        self.currentShippingState = stateList[0]
                    }*/
                }
            } else {
                self.shippingStateTextField.inputView = nil
            }
        })
    }
    
    private func initStateForCurrentBillingCountry(countryID: String) {
        State.GetStateByCountryID(countryID, completeHandler: {(stateList) in
            if stateList.count > 0 {
                self.billingStateList[countryID] = stateList
                dispatch_async(dispatch_get_main_queue()) {
                    self.billingStateTextField.text = stateList[0].getName()
                    self.currentBillingState = stateList[0]
                    /*if ((self.billingStateTextField.text?.isEmpty) != nil) {
                        let state = self.getStateByName(self.billingStateTextField.text!)
                        if state.getID() > 0 {
                            self.currentBillingState = state
                        }
                    } else {
                        self.billingStateTextField.text = stateList[0].getName()
                        self.currentBillingState = stateList[0]
                    }*/
                }
            } else {
                self.billingStateTextField.inputView = nil
            }
        })
    }
    
    private func getStateByName(stateName: String) -> State {
        if let states = shippingStateList[(currentShippingCountry.getCountryID())] {
            for state in states {
                if state.getName() == stateName {
                    return state
                }
            }
        }
        return State()
    }
    
    
    private func fillShippingAddressFields () {
        // Get shipping address from current order
        if order != nil {
            self.shippingNameTextField.text = order?.userShippingAddress.getFirstName()
            self.shippingLastNameTextField.text = order?.userShippingAddress.getLastName()
            self.shippingCompanyNameTextField.text = order?.userShippingAddress.getCompanyName()
            self.shippingPhoneNumberTextField.text = order?.userShippingAddress.getPhone()
            self.shippingAddressTextField.text = order?.userShippingAddress.getAddres()
            self.shippingAddressTwoTextField.text = order?.userShippingAddress.getAddressTwo()
            self.shippingCityTextField.text = order?.userShippingAddress.getCity()
            self.shippingCountryTextField.text = LiveCartController.sharedInstance().getCountryNameByCode((order?.userShippingAddress.getCountryID())!)
            self.shippingStateTextField.text = order?.userShippingAddress.getStateName()
            self.shippingPostalCodeTextField.text = order?.userShippingAddress.getPostalCode()
        }
    }
    
    private func fillBillingAddressFields () {
        // Get shipping address from current order
        if order != nil {
            self.billingNameTextField.text = order?.userBillingAddress.getFirstName()
            self.billingLasNameTextField.text = order?.userBillingAddress.getLastName()
            self.billingCompanyNameTextField.text = order?.userBillingAddress.getCompanyName()
            self.billingPhoneNumberTextField.text = order?.userBillingAddress.getPhone()
            self.billingAddressTextField.text = order?.userBillingAddress.getAddres()
            self.billingAddressTwoTextField.text = order?.userBillingAddress.getAddressTwo()
            self.billingCityTextField.text = order?.userBillingAddress.getCity()
            self.billingCountryTextField.text = LiveCartController.sharedInstance().getCountryNameByCode((order?.userBillingAddress.getCountryID())!)
            self.billingStateTextField.text = order?.userBillingAddress.getStateName()
            self.billingPostalCodeTextField.text = order?.userBillingAddress.getPostalCode()
        }
    }
    
    private func startCheckoutViewController() {
        let shippingMethodViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ShippingMethodViewController") as! ShippingMethodViewController
        self.navigationController?.pushViewController(shippingMethodViewController, animated: true)
        
    }
    
    @IBAction func nextButtonAction(sender: AnyObject) {
        if billingSwitch.on {
            if chekcShippingAddressField() {
                busyAlertController!.display()
                updateShippingAddress({() in
                    OrderController.sharedInstance().UpdateUserOrder((UserController.sharedInstance().getUser()?.ID)!, completeHandler: {(success) in
                        self.busyAlertController!.finish()
                    })
                })
            } else {
                print("Please complete all shipping address fileds")
            }
        } else {
            if self.chekcShippingAddressField() && self.checkBillingAddressFiled() {
                busyAlertController!.display()
                updateShippingAddress({() in
                    self.updateBillingAddress({() in
                        OrderController.sharedInstance().UpdateUserOrder((UserController.sharedInstance().getUser()?.ID)!, completeHandler: {(success) in
                            self.busyAlertController!.finish()
                        })
                    })
                })
            }else {
                print("Please complete all shipping and billing address fileds")
            }
        }
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
    
    private func chekcShippingAddressField() -> Bool {
        if !(shippingNameTextField.text!.isEmpty || shippingLastNameTextField.text!.isEmpty ||
            shippingCompanyNameTextField.text!.isEmpty || shippingPhoneNumberTextField.text!.isEmpty ||
            shippingAddressTextField.text!.isEmpty /*|| shippingAddressTwoTextField.text!.isEmpty*/ ||
            shippingCityTextField.text!.isEmpty || shippingCountryTextField.text!.isEmpty ||
            shippingStateTextField.text!.isEmpty || shippingPostalCodeTextField.text!.isEmpty)
        {
            return true
        }
        return false
    }
    
    private func checkBillingAddressFiled() -> Bool {
        if !(billingNameTextField.text!.isEmpty || billingLasNameTextField.text!.isEmpty ||
            billingCompanyNameTextField.text!.isEmpty || billingPhoneNumberTextField.text!.isEmpty ||
            billingAddressTextField.text!.isEmpty /*|| billingAddressTwoTextField.text!.isEmpty*/ ||
            billingCityTextField.text!.isEmpty || billingCountryTextField.text!.isEmpty ||
            billingStateTextField.text!.isEmpty || billingPostalCodeTextField.text!.isEmpty)
        {
            return true
        }
        return false
    }
    
    private func updateShippingAddress(completeHandler: () -> Void) {
        order?.userShippingAddress.setFirstName(shippingNameTextField.text!)
        order?.userShippingAddress.setLastName(shippingLastNameTextField.text!)
        order?.userShippingAddress.setCompanyName(shippingCompanyNameTextField.text!)
        order?.userShippingAddress.setPhone(shippingPhoneNumberTextField.text!)
        order?.userShippingAddress.setAddress(shippingAddressTextField.text!)
        order?.userShippingAddress.setAddressTwo(shippingAddressTwoTextField.text!)
        order?.userShippingAddress.setCity(shippingCityTextField.text!)
        order?.userShippingAddress.setCountryID(currentShippingCountry.getCountryID())
        //order?.userShippingAddress.setStateName(shippingStateTextField.text!)
        order?.userShippingAddress.setStateID(getStateByName(shippingStateTextField.text!).getID())
        order?.userShippingAddress.setPostalCode(shippingPostalCodeTextField.text!)
        
        let params = order?.userShippingAddress.getXML((order?.userShippingAddress.getID())!)
        order?.userShippingAddress.updateUdress(params!,completeHandler:{(userAddress) in
            OrderController.sharedInstance().UpdateUserOrder((UserController.sharedInstance().getUser()?.ID)!, completeHandler: {(sucess) in
                completeHandler()
            })
        })
        //completeHandler()
    }
    
    private func updateBillingAddress(completeHandler: () -> Void) {
        order?.userBillingAddress.setFirstName(billingNameTextField.text!)
        order?.userBillingAddress.setLastName(billingLasNameTextField.text!)
        order?.userBillingAddress.setCompanyName(billingCompanyNameTextField.text!)
        order?.userBillingAddress.setPhone(billingPhoneNumberTextField.text!)
        order?.userBillingAddress.setAddress(billingAddressTextField.text!)
        order?.userBillingAddress.setAddressTwo(billingAddressTwoTextField.text!)
        order?.userBillingAddress.setCity(billingCityTextField.text!)
        order?.userBillingAddress.setCountryID(currentBillingCountry.getCountryID())
        //order?.userBillingAddress.setStateName(billingStateTextField.text!)
        order?.userBillingAddress.setStateID(getStateByName(billingStateTextField.text!).getID())
        order?.userBillingAddress.setPostalCode(billingPostalCodeTextField.text!)
        
        let params = order?.userBillingAddress.getXML((order?.userBillingAddress.getID())!)
        order?.userBillingAddress.updateUdress(params!,completeHandler: {(userAddress) in
            OrderController.sharedInstance().UpdateUserOrder((UserController.sharedInstance().getUser()?.ID)!, completeHandler: {(sucess) in
                completeHandler()
            })
        })
        //completeHandler()
    }
    
    private func setEnableBillingTexTField(enabled: Bool) {
        billingNameTextField.enabled = enabled
        billingLasNameTextField.enabled = enabled
        billingCompanyNameTextField.enabled = enabled
        billingPhoneNumberTextField.enabled = enabled
        billingAddressTextField.enabled = enabled
        billingAddressTwoTextField.enabled = enabled
        billingCityTextField.enabled = enabled
        billingStateTextField.enabled = enabled
        billingStateTextField.enabled = enabled
        billingPostalCodeTextField.enabled = enabled
        billingCountryTextField.enabled = enabled
        if enabled {
            billingNameTextField.textColor = UIColor.blackColor()
            billingLasNameTextField.textColor = UIColor.blackColor()
            billingCompanyNameTextField.textColor = UIColor.blackColor()
            billingPhoneNumberTextField.textColor = UIColor.blackColor()
            billingAddressTextField.textColor = UIColor.blackColor()
            billingAddressTwoTextField.textColor = UIColor.blackColor()
            billingCityTextField.textColor = UIColor.blackColor()
            billingStateTextField.textColor = UIColor.blackColor()
            billingStateTextField.textColor = UIColor.blackColor()
            billingPostalCodeTextField.textColor = UIColor.blackColor()
            billingCountryTextField.textColor = UIColor.blackColor()
        } else {
            billingNameTextField.textColor = UIColor.lightGrayColor()
            billingLasNameTextField.textColor = UIColor.lightGrayColor()
            billingCompanyNameTextField.textColor = UIColor.lightGrayColor()
            billingPhoneNumberTextField.textColor = UIColor.lightGrayColor()
            billingAddressTextField.textColor = UIColor.lightGrayColor()
            billingAddressTwoTextField.textColor = UIColor.lightGrayColor()
            billingCityTextField.textColor = UIColor.lightGrayColor()
            billingStateTextField.textColor = UIColor.lightGrayColor()
            billingStateTextField.textColor = UIColor.lightGrayColor()
            billingPostalCodeTextField.textColor = UIColor.lightGrayColor()
            billingCountryTextField.textColor = UIColor.lightGrayColor()
        }
    }
    
    @IBAction func cencelAction(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    func didCancelBusyAlert() {
        print("cancel")
        self.startCheckoutViewController()
    }
}














