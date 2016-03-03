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
    var shippingService = [ShippingService]();
    var deliveryZoneDict = [String:DeliveryZone]()
    var selectedShippingMethod: ShippingService?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(title: "Next", style: .Plain, target: self, action: "nextAction:"), animated: true)
        self.navigationItem.rightBarButtonItem?.enabled = false
        self.title = "Method"
        
        shippingMethod.inputView = shippingMethodPicker
        shippingMethod.inputAccessoryView = toolBarButtonDone(0)
        shippingMethodPicker.delegate = self
        
        print(OrderController.sharedInstance().getCurrentOrder()?.ShippingAddress_countryID)
        
        // Obtain delivery zone
        let countryCoded = OrderController.sharedInstance().getCurrentOrder()?.ShippingAddress_countryID
        let countryName = OrderController.sharedInstance().getCurrentOrder()?.ShippingAddress_countryName
        let state = OrderController.sharedInstance().getCurrentOrder()?.ShippingAddress_stateName
    
        
        let deliveryZoneCountry = LiveCartController.sharedInstance().getDeliveryZoneCountryByCode(String(countryCoded!))
        for zoneCountry in deliveryZoneCountry {
            let zone = LiveCartController.sharedInstance().getDeliveryZoneByID(zoneCountry.deliveryZoneID)
            if zone != nil {
                deliveryZoneDict[(zone?.name)!] = zone
            }
        }
        
    
        for zone in LiveCartController.sharedInstance().getDeliveryZoneByName(countryName!) {
            if (deliveryZoneDict[zone.name] == nil) {
                deliveryZoneDict[zone.name] = zone
            }
        }
        
        for zone in LiveCartController.sharedInstance().getDeliveryZoneByName(state!) {
            if (deliveryZoneDict[zone.name] == nil) {
                deliveryZoneDict[zone.name] = zone
            }
        }
        
        
        for key in deliveryZoneDict {
            let serviceList = LiveCartController.sharedInstance().getShipmentServiceByDeliveryZoneID(key.1.ID)
            for service in serviceList {
                self.shippingService.append(service)
            }
        }
        
        print(shippingService.count)
        
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
        return shippingService.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return shippingService[row].name
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedShippingMethod = shippingService[row];
        shippingMethod.text = selectedShippingMethod?.name
        self.navigationItem.rightBarButtonItem?.enabled = true
        pickerView.resignFirstResponder()
    }
    
    
    func donePicker(sender: UIBarButtonItem) {
        if selectedShippingMethod != nil {
            Shipment().SetShipmentService((OrderController.sharedInstance().getCurrentOrder()?.ID)!, shippingMethodID: (selectedShippingMethod?.ID)!, completeHandler: {() in
                OrderController.sharedInstance().setShippingService(self.selectedShippingMethod!)
                dispatch_async(dispatch_get_main_queue()) {
                    self.navigationItem.rightBarButtonItem?.enabled = true
                }
            })
        } else {
            self.navigationItem.rightBarButtonItem?.enabled = false
        }
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
