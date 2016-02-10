//
//  CheckoutViewController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/5/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class CheckoutViewController: UITableViewController {
    
    
    // PayPal SDK Integration
    var payPalConfig = PayPalConfiguration()
    
    var environment:String = PayPalEnvironmentNoNetwork {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnectWithEnvironment(newEnvironment)
            }
        }
    }
    
    
    var isRunning: Bool = false
    private var products = [BrandItem]()
    private var address = [SimpleAddress]()
    private var orderTotalList = [OrderTotal]()
    private var productProperty = [String]()
    private var placeMethod = [String]()
    
    private var currency = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isRunning = true
        
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
            orderTota.subTotalBeforeTax += productItem.price
            BrandItem.getBrandItemByID(productItem.productID, completeHandler: {(item) in
                if item[0].parentID > 0 {
                    item[0].initParentNodeBrandItem({(brandItem) in
                        self.products.append(item[0])
                        self.RefreshTable()
                    })
                    item[0].getDefaultImage({(success) in
                        self.RefreshTable()
                    })
                }
                ProductVariationValue.GetProductVariationByProductID((item[0].ID), completeHandler: {(let productVariationValue) in
                    ProductVariation.GetProductVariationByID(productVariationValue.getVariationID(), completeHandler: {(let productVariation) in
                        dispatch_async(dispatch_get_main_queue()) {
                            self.productProperty.append(productVariation.getName())
                            self.RefreshTable()
                        }
                    })
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
            cell.name.text = products[indexPath.row].getName()
            cell.price.text = currency + " " + products[indexPath.row].getPrice().definePrices
            if productProperty.count > indexPath.row {
                cell.property.text = productProperty[indexPath.row]
            }
            
            if products[indexPath.row].image != nil {
                cell.photo.image = products[indexPath.row].image
            }
            
            if(products[indexPath.row].getPrice().definePrices == "") {
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    // do some task
                    PriceItem.getPriceBySKU((self.products[indexPath.row].getSKU()), completeHandler: {(priceItem) in
                        self.products[indexPath.row].setPrice(priceItem)
                        dispatch_async(dispatch_get_main_queue()) {
                            // update some UI
                            if self.isRunning {
                                tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
                            }
                        }
                    })
                }
            }
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
            //cell.placeOrderButton.setTitle(placeMethod[indexPath.row], forState: .Normal)
            //cell.placeOrderButton.titleLabel?.text = placeMethod[indexPath.row]
            //cell.placeOrderButton.setBackgroundImage(UIImage(named: "pay_pall_button"), forState: .Normal)
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











