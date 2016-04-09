//
//  CheckoutViewController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/5/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class CheckoutViewController: UITableViewController, PayPalPaymentDelegate {
    
    var isRunning: Bool = false
    private var products = [BrandItem]()
    private var orderProductItems = [Int64:OrderProductItem]()
    private var address = [SimpleAddress]()
    private var orderTotalList = [OrderTotal]()
    private var placeMethod = [String]()
    private var currency = String()
    private var shippingRate: ShippingRate?
    
    private var isSuccessInitProduct = false
    private var isSuccesInitProductProperty = false
    
    // PayPal SDK Integration
    var payPalConfig = PayPalConfiguration()
    var environment:String = /*PayPalEnvironmentProduction*/ PayPalEnvironmentSandbox /*PayPalEnvironmentNoNetwork*/ {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnectWithEnvironment(newEnvironment)
            }
        }
    }
    var acceptCreditCards: Bool = true {
        didSet {
            payPalConfig.acceptCreditCards = acceptCreditCards
        }
    }
    
    // PayPal Payment delegate
    func payPalPaymentDidCancel(paymentViewController: PayPalPaymentViewController) {
        paymentViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func payPalPaymentViewController(paymentViewController: PayPalPaymentViewController, didCompletePayment completedPayment: PayPalPayment) {
        paymentViewController.dismissViewControllerAnimated(true, completion: { () -> Void in
            //completedPayment.confirmation
            let paymentResultDic = completedPayment.confirmation as NSDictionary
            let dicResponse: AnyObject? = paymentResultDic.objectForKey("response")
            let orderID = OrderController.sharedInstance().getCurrentOrder()?.ID
            let gatewayTransactionID = dicResponse!.objectForKey("id")
            var amount = Float()  //OrderController.sharedInstance().getCurrentOrder()?.totalAmount
            
            for item in (OrderController.sharedInstance().getCurrentOrder()?.productItems)! {
                amount += (Float)(item.GetPrice())
            }
            
            Transaction.MakeTransaction(orderID!, currencyID: self.currency, amount: String(amount), gatewayTransactionID: String(gatewayTransactionID!), completeHandler: {(transaction) in
                OrderController.sharedInstance().UpdateUserOrder((UserController.sharedInstance().getUser()?.ID)!, completeHandler: {(success)in
                    dispatch_async(dispatch_get_main_queue()) {
                        //self.tabBarController!.tabBar.items![2].badgeValue = String(OrderController.sharedInstance().getCurrentOrder()!.productItems.count)
                        self.navigationController!.dismissViewControllerAnimated(true, completion: nil)
                    }
                })
            })
        })
    }
    
    private func PreparePayPalOrder() {
        let behaviour = NSDecimalNumberHandler(roundingMode:.RoundDown,
            scale: 2, raiseOnExactness: false,
            raiseOnOverflow: false, raiseOnUnderflow:
            false, raiseOnDivideByZero: false)
        
        
        var payPalItems = [PayPalItem]()
        /*var totalProductItem = Float();
        for var i = 0; i < products.count; i++ {
            let orderProductItem = orderProductItems[i]
            let property = products[i].getProductVariation().getName()
            let name = String(orderProductItems[i].name) + " " + String(property)
            let count = orderProductItem.count
            let price = String(orderProductItem.price)
            totalProductItem += orderProductItem.price * Float32(orderProductItem.count)
            let sku = orderProductItem.sku
            let paypalItem = PayPalItem(name: name, withQuantity: UInt(count), withPrice: NSDecimalNumber(string: price), withCurrency: currency, withSku: sku)
            payPalItems.append(paypalItem)
        }
        
        
        if(self.orderTotalList[0].HST > 0) {
            let hst = NSDecimalNumber(float: self.orderTotalList[0].HST).decimalNumberByRoundingAccordingToBehavior(behaviour)
            let taxHST = PayPalItem(name: "tax HST", withQuantity: UInt(1), withPrice: hst, withCurrency: currency, withSku: "hst")
            payPalItems.append(taxHST)
        }
        
        let currentShippingService = OrderController.sharedInstance().getShippingService()
        if  currentShippingService != nil {
            // Set shipping service price
            let shippingPrice = NSDecimalNumber(double: (Double)(self.orderTotalList[0].shippingPickUp)).decimalNumberByRoundingAccordingToBehavior(behaviour)
            
            let shippingServiceItem = PayPalItem(name: currentShippingService!.name, withQuantity: 1, withPrice: shippingPrice, withCurrency: currency, withSku: "shipment")
            payPalItems.append(shippingServiceItem)
        }*/
        
        // new
        let itemName = String(OrderController.sharedInstance().getCurrentOrder()?.ID)
        let price = NSDecimalNumber(double: (Double)((OrderController.sharedInstance().getCurrentOrder()?.totalAmount)!)).decimalNumberByRoundingAccordingToBehavior(behaviour)
        let paypalItem = PayPalItem(name: itemName, withQuantity: UInt(1), withPrice: price, withCurrency: currency, withSku: itemName)
        payPalItems.append(paypalItem)
        //end
        
        let subTotal = PayPalItem.totalPriceForItems(payPalItems).decimalNumberByRoundingAccordingToBehavior(behaviour)
        let shipping = NSDecimalNumber(string:"0.00")
        let tax = NSDecimalNumber(string: "0.00")
        
        let paymentDetail = PayPalPaymentDetails(subtotal: subTotal, withShipping: shipping, withTax: tax)
        let total = subTotal.decimalNumberByAdding(shipping).decimalNumberByAdding(tax)
        
        let payment = PayPalPayment(amount: total, currencyCode: (OrderController.sharedInstance().getCurrentOrder()?.currencyID)!, shortDescription: "illuminata", intent: .Sale)
        payment.items = payPalItems
        payment.paymentDetails = paymentDetail
        
        if(payment.processable) {
            let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
            presentViewController(paymentViewController!, animated: true, completion: nil    )
        } else {
            print("Payment not processable \(payment)")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isRunning = true
        
        // PayPal SDK integration
        payPalConfig.acceptCreditCards = acceptCreditCards
        payPalConfig.merchantName = "illuminataeyewear"
        payPalConfig.languageOrLocale = NSLocale.preferredLanguages()[0] 
        payPalConfig.payPalShippingAddressOption = .PayPal
        
        PayPalMobile.preconnectWithEnvironment(environment)
        
        
        let order = OrderController.sharedInstance().getCurrentOrder()
        currency = (order?.currencyID)!
        
        let user_address = SimpleAddress()
        user_address.fullName = (order?.ShippingAddress_fullName)!
        user_address.company = (order?.ShippingAddress_companyName)!
        user_address.address = (order?.ShippingAddress_address1)! + " " + (order?.ShippingAddress_address2)!
        user_address.city = (order?.ShippingAddress_city)!
        user_address.stateAndPostalCode = (order?.ShippingAddress_stateName)! + " " + (order?.ShippingAddress_postalCode)!
        user_address.city = (order?.ShippingAddress_city)!
        address.append(user_address)

        
        for productItem in (order?.productItems)! {
            orderProductItems[productItem.productID] = productItem
            print("Price : " + String(productItem.GetPrice()))
            BrandItem().getBrandItemByID(productItem.productID, completeHandler: {(let brandItems) in
                brandItems[0].fullInitProduct({(brandItem) in
                    self.products.append(brandItem)
                    self.RefreshTable()
                    if self.products.count == self.orderProductItems.count {
                        self.initOrderTotal({() in
                            self.RefreshTable()
                        })
                    }
                })
            })
        }
        
        placeMethod.append("pay_pall_button")
        //placeMethod.append("beanstream_button")
        
        tableView.separatorStyle = .None
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(false)
        isRunning = false
    }
    
    private func initOrderTotal(completeHandler:() -> Void) {
        let shippingMethod = OrderController.sharedInstance().getShippingService()
        if shippingMethod != nil {
            ShippingRate().GetShippingRateByServiceID((shippingMethod?.ID)!, completeHandler: {(shippingRateList) in
                let shippingRate = shippingRateList[0]
                OrderController.sharedInstance().UpdateUserOrder((UserController.sharedInstance().getUser()?.ID)!, completeHandler: {(success) in
                    let order = OrderController.sharedInstance().getCurrentOrder()
                    let orderTota = OrderTotal()
                    
                    for item in (self.products) {
                        orderTota.subTotalBeforeTax += (Float32)(self.orderProductItems[item.ID]!.GetPrice()) * (Float32)(self.orderProductItems[item.ID]!.count)
                    }
                    
                    orderTota.orderTotal = (order?.totalAmount)!
                    
                    var rate = Float()
                    if OrderController.sharedInstance().getShippingService() != nil {
                        // Calculate shipping rate = ShippingRate.flatCharge + (itemCount * ShippingRate.perItemCharge) + (Product.shippingWeight * ShippingRate.perKgCharge)
                        var productShippingWeight = Float()
                        
                        /*for index in 0...self.products.count - 1 {
                            productShippingWeight += (self.products[index].getShippingWeight() * Float32(self.orderProductItems[index].count))
                        }*/
                        for item in self.products {
                            productShippingWeight += (item.getShippingWeight() * Float32((self.orderProductItems[item.ID]?.count)!))
                        }
                        rate = shippingRate.flatCharge + (Float32(self.products.count) * shippingRate.perItemCharge) + (productShippingWeight * shippingRate.perKgCharge)
                        orderTota.shippingPickUp = rate
                    }
                    
                    if order?.totalAmount > 0 {
                        let hst = (order?.totalAmount)! - orderTota.subTotalBeforeTax - orderTota.shippingPickUp
                        if hst >= 0 {
                            orderTota.HST = hst //(order?.totalAmount)! - orderTota.subTotalBeforeTax - rate
                        }
                    }
                    self.orderTotalList.append(orderTota)
                    completeHandler()
                
                })
            })
        }
    }
    
    private func calculateShippingRate(shippingService: ShippingService) -> Float32{
        
        return 0
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return products.count
        } else if section == 1 {
            return orderTotalList.count
        } else if section == 2 {
            return address.count
        } else if section == 3 {
            return placeMethod.count
        } else if section == 4 {
            return 1
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("ProductItemViewCell", forIndexPath: indexPath) as! ProductItemViewCell
            let brandItem = products[indexPath.row]
            
            cell.name.text = products[indexPath.row].getName()
            cell.price.text = String(self.orderProductItems[brandItem.ID]!.GetPrice()) //brandItem.getPrice().definePrices
            cell.property.text = brandItem.getProductVariation().getName()
            cell.photo.image = brandItem.getImage()
            cell.currency.text = currency
            
            return cell
            
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("OrderTotalViewCell", forIndexPath: indexPath) as! OrderTotalViewCell
            cell.subTotalBeforeTax.text = String(orderTotalList[indexPath.row].subTotalBeforeTax)
            cell.HST.text = String(orderTotalList[indexPath.row].HST)
            cell.orderTotal.text = String(orderTotalList[indexPath.row].orderTotal)
            cell.shippingPickUp.text = String(orderTotalList[indexPath.row].shippingPickUp)
            cell.setCurrency(currency)
            return cell
            
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier("CustomerAddressCellView", forIndexPath: indexPath) as! CustomerAddressCellView
            cell.fullName.text = address[indexPath.row].fullName
            cell.company.text = address[indexPath.row].company
            cell.address.text = address[indexPath.row].address
            cell.city.text = address[indexPath.row].city
            cell.stateAndPostalCode.text = address[indexPath.row].stateAndPostalCode
            cell.country.text = address[indexPath.row].country
            return cell
            
        } else if indexPath.section == 3{
            let cell = tableView.dequeueReusableCellWithIdentifier("PlaceOrderCellView", forIndexPath: indexPath) as! PlaceOrderCellView
            cell.placeOrderButton.tag = indexPath.row
            cell.placeOrderButton.setImage(UIImage(named: placeMethod[indexPath.row]), forState: .Normal)
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("EmptyCell", forIndexPath: indexPath)
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Item(s) in your cart"
        } else if section == 1 {
            return String("Total tax")
        } else if section == 2{
            return String("Shipped to")
        } else if section == 3 {
            return String("Please select a payment method")
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 42
        } else if indexPath.section == 1{
            return 71
        } else if indexPath.section == 2 {
            return 113
        } else if indexPath.section == 3{
            return 50
        } else {
            return 50
        }
    }

    @IBAction func placeOrderAction(sender: AnyObject) {
        print(String((sender as! UIButton).tag) + " Plase order" )
        let tag = (sender as! UIButton).tag
        if tag == 0 {
            PreparePayPalOrder()
        }
    }
    
    func RefreshTable() {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            return
        })
    }
}

private class SimpleAddress {
    var fullName = String()
    var company = String()
    var address = String()
    var city = String()
    var stateAndPostalCode = String()
    var country = String()
}

private class OrderTotal {
    var subTotalBeforeTax = Float()
    var shippingPickUp = Float()
    var HST = Float()
    var orderTotal = Float()
}











