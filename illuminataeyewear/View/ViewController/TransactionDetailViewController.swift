//
//  TransactionDetailViewController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/29/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class TransactionDetailViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    var order: Order?
    var orderTax = Float32()
    var transaction = [Transaction]()
    var shipment: Shipment?
    var shippingService: ShippingService?
    
    var cellHeight = [NSIndexPath:CGFloat]()

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        if order != nil {
            self.title = order?.invoiceNumber
            Transaction.GetTransactionByOrderID((self.order?.ID)!, completeHandler: {(transactions) in
                if transactions.count > 0 {
                    self.transaction = transactions
                    self.RefreshTable()
                    dispatch_async(dispatch_get_main_queue()) {
                        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(title: "Support", style: .Plain, target: self, action: #selector(TransactionDetailViewController.suport(_:))), animated: true)
                    }
                }
            })
            
            Shipment().GetShipmentByOrerID((self.order?.ID)!, completeHandler: {(shipments) in
                if shipments.count > 0 {
                    self.shipment = shipments[0]
                    if self.shipment != nil {
                        LiveCartController.sharedInstance().getShippingServiceByID((self.shipment?.shippingServiceID)!, completeHandler: {(shippingService) in
                            self.shippingService = shippingService
                            self.RefreshTable()
                        })
                    }
                }
            })
            self.order?.GetTaxAmount((self.order?.ID)!, completeHandler: {(value, message, error) in
                //print("Tax Amount : " + String(value))
                self.orderTax = value
                self.RefreshTable()
            })
        }
        
        
        //self.navigationItem.setRightBarButtonItem(UIBarButtonItem(title: "Suport", style: .Plain, target: self, action: #selector(TransactionDetailViewController.suport(_:))), animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func suport(target: AnyObject) {
        //let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        //let suportNavigationController = storyBoard.instantiateViewControllerWithIdentifier("SuportNavigationController") as! UINavigationController
        //self.presentViewController(suportNavigationController, animated: true, completion: nil)
        let suportViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SuportViewController") as! SuportViewController
        suportViewController.orderID = self.order?.ID
        self.navigationController?.pushViewController(suportViewController, animated: true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if self.order != nil {
                return (self.order?.productItems.count)!
            }else {
                return 0
            }
        } else if section == 1 {
            return self.transaction.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("TransactionDetailProductCell", forIndexPath: indexPath) as! TransactionDetailProductCell
            cell.name.text = self.order?.productItems[indexPath.row].name
            cell.SKU.text = self.order?.productItems[indexPath.row].sku
            cell.price.text = String(self.order!.getCurrency()) + " " + String(format: "%.2f", self.order!.productItems[indexPath.row].GetPrice(false))
            cell.quantity.text = String(self.order!.productItems[indexPath.row].count)
            let subtotal = Float32(self.order!.productItems[indexPath.row].GetPrice(false)) * Float32(self.order!.productItems[indexPath.row].count)
            cell.subtotal.text = String(self.order!.getCurrency()) + " " + String(format: "%.2f", subtotal)
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("TransactionDetailViewCell", forIndexPath: indexPath) as! TransactionDetailViewCell
            var orderTotal = String()
            if self.order != nil {
                orderTotal.appendContentsOf((self.order?.getCurrency())!)
                orderTotal.appendContentsOf(" ")
            }
            orderTotal.appendContentsOf(String(format: "%.2f", (transaction[indexPath.row].amount)))
            cell.orderTotal.text = orderTotal //String(format: "%.2f", transaction[indexPath.row].amount)
            
            var shippingServiceLabel = String()
            var taxes = String()
            if self.shippingService != nil {
                shippingServiceLabel.appendContentsOf((self.shippingService?.name)!)
            }
            if self.order != nil {
                shippingServiceLabel.appendContentsOf(" ")
                shippingServiceLabel.appendContentsOf((self.order?.getCurrency())!)
                shippingServiceLabel.appendContentsOf(" ")
                taxes.appendContentsOf((self.order?.getCurrency())!)
                taxes.appendContentsOf(" ")
            }
            if self.shipment != nil {
                //cell.shippingService.text = String(format: "%.2f",(shipment?.taxAmount)!)
                shippingServiceLabel.appendContentsOf(String(format: "%.2f",(shipment?.shippingAmount)!))
                taxes.appendContentsOf(String(format: "%.2f", self.orderTax))
            }
            cell.shippingService.text = shippingServiceLabel
            cell.taxes.text = taxes
            cell.shippingService.numberOfLines = 0
            cell.shippingService.sizeToFit()
            
            self.cellHeight[indexPath] = cell.shippingService.frame.height + 127
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 135
        } else if indexPath.section == 1 {
            var h = self.cellHeight[indexPath]
            if h == nil {
                h = 0
            }
            return h!
        }
        return 0
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Order Total:"
        }
        return nil
    }
    
    func RefreshTable() {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            return
        })
    }
}
