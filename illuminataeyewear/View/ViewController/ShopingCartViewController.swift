//
//  ShopingCartViewController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 1/30/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class ShopingCartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, BusyAlertDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var checkoutButton: UIBarButtonItem!
    @IBOutlet weak var emptyCart: UIScrollView!
    
    var isRunning: Bool = false
    var brandItems = [Int64:Array<BrandItem>]()
    var orderProductItems = [OrderProductItem]()
    var coupons = [OrderCoupon]()
    
    let cellIdentifier = "OrderViewCell"
    var couponCode = String()
    
    var busyAlertController: BusyAlert?
    var needUpdateOrder: Bool = false
    
    var lensesProduct = [BrandItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        isRunning = true
        tableView.hidden = true
        checkoutButton.enabled = false
        
        OrderController.sharedInstance().getCouponForCurrentOrder({(coupons, message, error) in
            self.coupons = coupons
            //self.RefreshTable()
        })
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !UserController.sharedInstance().isAnonimous() {
            let order = OrderController.sharedInstance().getCurrentOrder()
            if order?.productItems.count == 0 {
                orderProductItems = [OrderProductItem]()
                brandItems = [Int64:Array<BrandItem>]()
                
                tableView.hidden = true
                emptyCart.hidden = false
                checkoutButton.enabled = false
                activityIndicator.stopAnimating()
                LiveCartController.TabBarUpdateBadgeValue(self.tabBarController!);
                
            } else if Order.GetOrderedProductCount((order?.productItems)!) > Order.GetOrderedProductCount(orderProductItems) || self.needUpdateOrder {
                self.needUpdateOrder = false
                checkoutButton.enabled = false
                tableView.hidden = true
                emptyCart.hidden = true
                activityIndicator.startAnimating()
                
                orderProductItems = [OrderProductItem]()
                brandItems = [Int64:Array<BrandItem>]()
                
                if order?.productItems.count > 0 {
                    LiveCartController.TabBarUpdateBadgeValue(self.tabBarController!)
                    orderProductItems = (order?.productItems)!
                    
                    for itemProduct in (order?.productItems)! {
                        BrandItem().getBrandItemByID(itemProduct.productID, completeHandler: {(items) in
                            let id = itemProduct.ID
                            items[0].fullInitProduct({(item) in
                                self.brandItems[id] = [item]
                                self.activityIndicator.stopAnimating()
                                if self.brandItems.count == self.orderProductItems.count {
                                    dispatch_async(dispatch_get_main_queue()) {
                                        self.checkoutButton.enabled = true
                                        self.activityIndicator.stopAnimating()
                                        self.activityIndicator.hidden = true
                                    }
                                    self.RefreshTable()
                                }
                                //self.RefreshTable()
                            })
                        })
                    }
                }
            } else if order?.productItems.count == orderProductItems.count {
                orderProductItems = (order?.productItems)!
                self.checkoutButton.enabled = true
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
                self.RefreshTable()
            }
            
            self.navigationItem.leftBarButtonItem = editButtonItem()
        } else {
            self.emptyCart.hidden = false
            self.tableView.hidden = true
            self.checkoutButton.enabled = false
        }
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(false)
        isRunning = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            tableView.frame.size.height -= keyboardSize.height
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            tableView.frame.size.height += keyboardSize.height
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        } else if section == 1 {
            return brandItems.count
        } else if section == 2 {
            return 1
        } else if section == 3 {
            return coupons.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return UITableViewCell()
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! OrderViewCell
    
            
            let orderProductItem = self.orderProductItems[indexPath.row]
            let brandItem = brandItems[orderProductItem.ID]![0]
            let price = orderProductItems[indexPath.row].GetPrice() //Float(brandItem.getPrice().definePrices)
            
            cell.name.text = brandItem.getName()
            cell.price.text = String(orderProductItems[indexPath.row].count) + String(" x ") + String(orderProductItems[indexPath.row].GetPrice())/*brandItem.getPrice().definePrices*/
            cell.photo.image = brandItem.getImage()
            //cell.quantity.text = String(orderProductItems[indexPath.row].count)
            cell.property.text = brandItem.getProductVariation().getName()
            cell.cost.text = OrderController.sharedInstance().getCurrentOrderCurrency() + " " + String(Float64(orderProductItem.count) * price)
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier("AddCouponViewCell", forIndexPath: indexPath) as! AddCouponViewCell
            cell.addCouponButton.addTarget(self, action: "addCoupon:", forControlEvents: UIControlEvents.TouchUpInside)
            cell.textField.delegate = self
            return cell
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCellWithIdentifier("CouponViewCell", forIndexPath: indexPath) as! CouponViewCell
            cell.label.text = self.coupons[indexPath.row].couponCode
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 1 {
            return true
        }
        return false
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let orderID = OrderController.sharedInstance().getCurrentOrder()?.ID
            Order.deleteItemFormCart(self.orderProductItems[indexPath.row].ID, orderID: orderID!, completeHandler: {() in
                OrderController.sharedInstance().UpdateUserOrder((UserController.sharedInstance().getUser()?.ID)!, completeHandler: {(success) in
                    dispatch_async(dispatch_get_main_queue()) {
                        self.brandItems.removeValueForKey(self.orderProductItems[indexPath.row].ID)    //.removeAtIndex(indexPath.row)
                        self.orderProductItems = (OrderController.sharedInstance().getCurrentOrder()?.productItems)!
                        if self.orderProductItems.count == 0 {
                            self.checkoutButton.enabled = false
                        }
                        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                        LiveCartController.TabBarUpdateBadgeValue(self.tabBarController!)
                    }
                })
            })
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 90
        } else if indexPath.section == 1 {
            return 91
        } else if indexPath.section == 2 {
            return 65
        } else if indexPath.section == 3 {
            return 30
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Products in cart"
        } else if section == 2 {
            return "Discount coupons"
        } else if section == 3 && self.coupons.count > 0 {
            return "Coupons code"
        }
        return nil
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            if self.brandItems[self.orderProductItems[indexPath.row].ID]![0].categoryID == 267 {
                let productOptionNavigationController = storyBoard.instantiateViewControllerWithIdentifier("ProductOptionNavigationController") as! UINavigationController
                self.presentViewController(productOptionNavigationController, animated: true, completion: nil)
                let productOptionViewController = productOptionNavigationController.viewControllers.first as! ProductOptionViewController
                productOptionViewController.brandItem = self.brandItems[self.orderProductItems[indexPath.row].ID]![0]
                productOptionViewController.orderProductItem = self.orderProductItems[indexPath.row]
                productOptionViewController.closeHandler = {(needUpdate)in
                    print("Order should be update " + String(needUpdate))
                    self.needUpdateOrder = needUpdate
                }
                
            } else {
                let navigationController = storyBoard.instantiateViewControllerWithIdentifier("ProductInfoNavigationController") as! UINavigationController
                self.presentViewController(navigationController, animated: true, completion: nil)
                let productInfoViewController = navigationController.viewControllers.first as! ProductInfoViewController
                productInfoViewController.brandItem = self.brandItems[self.orderProductItems[indexPath.row].ID]![0]
            }
        }
    }
    
    @IBAction func checkoutAction(sender: AnyObject) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let addressNavigationController = storyboard.instantiateViewControllerWithIdentifier("AddressNavigationController") as! UINavigationController
        self.presentViewController(addressNavigationController, animated: true, completion: nil)
    }
    
    
    func RefreshTable() {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.hidden = false
            self.tableView.reloadData()
            return
        })
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        self.couponCode = textField.text!
        return false
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        self.couponCode.appendContentsOf(string)
        return true
    }
    
    func addCoupon(target: AnyObject) {
        self.busyAlertController = nil
        self.busyAlertController = BusyAlert(title: "", message: "", button: "OK", presentingViewController: self)
        self.busyAlertController?.delegate = self
        self.busyAlertController?.display()
        
        OrderCoupon.AddCoupon((OrderController.sharedInstance().getCurrentOrder()?.ID)!, couponCode: couponCode, completeHandler: {(coupons, message, error) in
            if error != nil {
                self.busyAlertController?.message = (error?.localizedDescription)!
            } else if message != nil {
                self.busyAlertController?.message = message!
            } else {
                self.busyAlertController?.message = "Try again"
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.busyAlertController?.finish()
            }
        })
    }
    
    func didCancelBusyAlert() {
        OrderController.sharedInstance().getCouponForCurrentOrder({(coupons, message, error) in
            self.coupons = coupons
            if coupons.count > 0 {
            }
            self.RefreshTable()
        })
    }
    
    // Lenses
    private func ObtainLensesProductItem() {
        let paramString = "xml=<product><list><categoryID>267</categoryID><isEnabled>1</isEnabled></list></product>"
        BrandItem.getItems(paramString, completeHandler: {(brandItems) in
            self.lensesProduct = brandItems
            self.RefreshTable()
        })
    }
}