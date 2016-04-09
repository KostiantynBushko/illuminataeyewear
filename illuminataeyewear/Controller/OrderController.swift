//
//  OrderController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/2/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation


class OrderController {
    private static let DEFAULT_CURRENCY = "CAD $"
    
    private static let _instance = OrderController()
    
    private var shippingService: ShippingService?
    private var coupons = [OrderCoupon]()
    
    private init(){
        successCompleteHandler = nil
        shippingService = nil
    }
    
    var orders = [Order]()
    
    private var successCompleteHandler: ((successInit: Bool) -> Void)?
    
    
    class func sharedInstance() -> OrderController {
        return _instance
    }
    
    func dropOrder() {
        self.orders = [Order]()
    }
    
    func UpdateUserOrder(userID: Int64, completeHandler:(succesInit: Bool) -> Void) {
        self.successCompleteHandler = completeHandler
        Order.GetOrdersList(userID, isFinalised: false, completeHandler: {(listOrders) in
            if listOrders != nil && listOrders?.count > 0 {
                self.orders = [Order]()
                self.orders = listOrders!
                if self.orders.count > 0 {
                    self.orders.sortInPlace { $0.ID > $1.ID }
                }
                Order.GetOrderByID(self.orders[0].ID, completeHandler: {(order) in
                    self.orders[0] = order
                    if self.successCompleteHandler != nil {
                        completeHandler(succesInit: true)
                    }
                })
            } else {
                // Create new order
                Order.CreateNewOrder(userID, completeHandler: {(listOrders) in
                    self.orders = [Order]()
                    self.orders = listOrders!
                    if self.orders.count > 0 {
                        self.orders.sortInPlace { $0.ID > $1.ID }
                    }
                    if self.successCompleteHandler != nil {
                        completeHandler(succesInit: true)
                    }
                    self.coupons = [OrderCoupon]()
                    self.getCouponForCurrentOrder({(coupons, message, error) in
                        self.coupons = coupons
                    })
                })
            }
        })
    }
    
    func getCouponForCurrentOrder(completeHandler:(Array<OrderCoupon>, String?, NSError?) -> Void) {
        if coupons.count > 0 {
            completeHandler(self.coupons, nil, nil)
        } else {
            if self.orders.count ==  0 || getCurrentOrder() == nil {
                completeHandler(self.coupons, nil, nil)
            } else {
                OrderCoupon.GetOrderCoupons((self.getCurrentOrder()?.ID)!, completeHandler: {(coupons, message, error) in
                    completeHandler(coupons, message, error)
                })
            }
        }
    }
    
    func getCurrentOrderID() -> Int64 {
        if orders.count > 0 {
            return orders[0].ID
        }
        return 0
    }
    func getCurrentOrder() -> Order? {
        if orders.count > 0 {
            return orders[0]
        }
        return nil
    }
    
    func getCurrentOrderCurrency() -> String {
        if orders.count > 0 {
            return orders[0].currencyID
        }
        return OrderController.DEFAULT_CURRENCY
    }
    
    func setShippingService(shippingService: ShippingService) {
        self.shippingService = shippingService
    }
    
    func getShippingService() -> ShippingService? {
        return shippingService
    }
    
}
