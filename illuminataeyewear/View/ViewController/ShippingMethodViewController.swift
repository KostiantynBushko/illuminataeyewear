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
    
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var shippingPriceLabel: UILabel!
    let shippingMethodPicker = UIPickerView();
    var shippingService = [ShippingService]();
    var deliveryZoneDict = [String:DeliveryZone]()
    var selectedShippingMethod: ShippingService?
    var products = [BrandItem]()
    private var orderProductItems = [Int64:OrderProductItem]()
    
    
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
            selectedShippingMethod = shippingService[0];
            shippingMethod.text = selectedShippingMethod?.name
            donePicker(nil)
        }
        
        let order = OrderController.sharedInstance().getCurrentOrder()
        for productItem in (order?.productItems)! {
            orderProductItems[productItem.productID] = productItem
            print("Price : " + String(productItem.GetPrice()))
            BrandItem().getBrandItemByID(productItem.productID, completeHandler: {(let brandItems) in
                brandItems[0].fullInitProduct({(brandItem) in
                    self.products.append(brandItem)
                    dispatch_async(dispatch_get_main_queue()) {
                        if self.products.count == self.orderProductItems.count {
                            self.scrollView.hidden = false
                        }
                    }
                })
            })
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    func nextAction(selector: AnyObject) {
        let checkoutViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CheckoutViewController") as! CheckoutViewController
        checkoutViewController.products = self.products
        checkoutViewController.orderProductItems = self.orderProductItems
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
    
    
    func donePicker(sender: UIBarButtonItem?) {
        if selectedShippingMethod != nil {
            Shipment().SetShipmentService((OrderController.sharedInstance().getCurrentOrder()?.ID)!, shippingMethodID: (selectedShippingMethod?.ID)!, completeHandler: {() in
                OrderController.sharedInstance().setShippingService(self.selectedShippingMethod!)
                self.calculateShippingRate({(rate) in
                    dispatch_async(dispatch_get_main_queue()) {
                        self.navigationItem.rightBarButtonItem?.enabled = true
                        //print("RATE : " + String(rate))
                        self.shippingPriceLabel.text = "Price: " + OrderController.sharedInstance().getCurrentOrderCurrency() + " " + String(rate)
                    }
                })
                /*dispatch_async(dispatch_get_main_queue()) {
                    self.calculateShippingRate({(rate) in
                        dispatch_async(dispatch_get_main_queue()) {
                            self.navigationItem.rightBarButtonItem?.enabled = true
                            print("RATE : " + String(rate))
                            self.shippingPriceLabel.text = String(rate)
                        }
                    })
                }*/
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
    
    private func calculateShippingRate(completeHandler: (Float) -> Void) {
        let shippingMethod = OrderController.sharedInstance().getShippingService()
        if shippingMethod != nil {
            ShippingRate().GetShippingRateByServiceID((shippingMethod?.ID)!, completeHandler: {(shippingRateList) in
                let shippingRate = shippingRateList[0]
                var rate = Float()
                if OrderController.sharedInstance().getShippingService() != nil {
                    // Calculate shipping rate = ShippingRate.flatCharge + (itemCount * ShippingRate.perItemCharge) + (Product.shippingWeight * ShippingRate.perKgCharge)
                    var productShippingWeight = Float()
                    for item in self.products {
                        productShippingWeight += (item.getShippingWeight() * Float32((self.orderProductItems[item.ID]?.count)!))
                    }
                    rate = shippingRate.flatCharge + (Float32(self.products.count) * shippingRate.perItemCharge) + (productShippingWeight * shippingRate.perKgCharge)
                }
                completeHandler(rate)
                /*OrderController.sharedInstance().UpdateUserOrder((UserController.sharedInstance().getUser()?.ID)!, completeHandler: {(success) in
                    var rate = Float()
                    if OrderController.sharedInstance().getShippingService() != nil {
                        // Calculate shipping rate = ShippingRate.flatCharge + (itemCount * ShippingRate.perItemCharge) + (Product.shippingWeight * ShippingRate.perKgCharge)
                        var productShippingWeight = Float()
                        for item in self.products {
                            productShippingWeight += (item.getShippingWeight() * Float32((self.orderProductItems[item.ID]?.count)!))
                        }
                        rate = shippingRate.flatCharge + (Float32(self.products.count) * shippingRate.perItemCharge) + (productShippingWeight * shippingRate.perKgCharge)
                    }
                })*/
            })
        }
    }
}
