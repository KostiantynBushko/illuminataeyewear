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
    private var orderProductItems = [OrderProductItem]()
    private var address = [SimpleAddress]()
    private var orderTotalList = [OrderTotal]()
    //private var productsProperty = [String]()
    private var placeMethod = [String]()
    private var currency = String()
    
    private var isSuccessInitProduct = false
    private var isSuccesInitProductProperty = false
    
    // PayPal SDK Integration
    var payPalConfig = PayPalConfiguration()
    var environment:String = /*PayPalEnvironmentSandbox*/ PayPalEnvironmentNoNetwork {
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
        print("PayPal Payment Cancelled")
        paymentViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func payPalPaymentViewController(paymentViewController: PayPalPaymentViewController, didCompletePayment completedPayment: PayPalPayment) {
        print("PayPal Payment success")
        paymentViewController.dismissViewControllerAnimated(true, completion: { () -> Void in
            print("Here is your proof of payment : \(completedPayment.confirmation)")
            //completedPayment.confirmation
            self.navigationController!.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
    private func PreparePayPalOrder() {
        var payPalItems = [PayPalItem]()
        for var i = 0; i < products.count; i++ {
            let orderProductItem = orderProductItems[i]
            let property = products[i].getProductVariation().getName()
            let name = String(orderProductItems[i].name) + " " + String(property)
            let count = orderProductItem.count
            let price = String(orderProductItem.price)
            let sku = orderProductItem.sku
            let paypalItem = PayPalItem(name: name, withQuantity: UInt(count), withPrice: NSDecimalNumber(string: price), withCurrency: currency, withSku: sku)
            payPalItems.append(paypalItem)
        }
        let subTotal = PayPalItem.totalPriceForItems(payPalItems)
        
        let shipping = NSDecimalNumber(string: "0.00")
        let tax = NSDecimalNumber(string: "0.00")
        
        let paymentDetail = PayPalPaymentDetails(subtotal: subTotal, withShipping: shipping, withTax: tax)
        let total = subTotal.decimalNumberByAdding(shipping).decimalNumberByAdding(tax)
        
        let payment = PayPalPayment(amount: total, currencyCode: "CAD", shortDescription: "illuminataeyewear", intent: .Sale)
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
        
        let orderTota = OrderTotal()
        for productItem in (order?.productItems)! {
            orderProductItems.append(productItem)
            orderTota.subTotalBeforeTax += productItem.price
            BrandItem.getBrandItemByID(productItem.productID, completeHandler: {(let brandItems) in
                brandItems[0].fullInitProduct({(brandItem) in
                    self.products.append(brandItem)
                    self.RefreshTable()
                })
            })
        }
        
        
        orderTota.HST = 0 //(order?.totalAmount)! - orderTota.subTotalBeforeTax
        orderTota.orderTotal = orderTota.subTotalBeforeTax //(order?.totalAmount)!
        orderTotalList.append(orderTota)
        
        placeMethod.append("pay_pall_button")
        placeMethod.append("beanstream_button")
        
        tableView.separatorStyle = .None
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(false)
        isRunning = false
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
            cell.price.text = currency + " " + brandItem.getPrice().definePrices
            cell.property.text = brandItem.getProductVariation().getName()
            cell.photo.image = brandItem.image
            
            return cell
            
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("OrderTotalViewCell", forIndexPath: indexPath) as! OrderTotalViewCell
            cell.subTotalBeforeTax.text = currency + " " + String(orderTotalList[indexPath.row].subTotalBeforeTax)
            cell.HST.text = currency + " " + String(orderTotalList[indexPath.row].HST)
            cell.orderTotal.text = currency + " " + String(orderTotalList[indexPath.row].orderTotal)
            cell.shippingPickUp.text = currency + " " + String(orderTotalList[indexPath.row].shippingPickUp)
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











