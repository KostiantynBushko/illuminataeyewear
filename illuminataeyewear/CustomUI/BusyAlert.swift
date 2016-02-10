//
//  BusyAlert.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/8/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation
import UIKit

protocol BusyAlertDelegate {
    
    func didCancelBusyAlert()
    
}


class BusyAlert {
    
    var busyAlertController: UIAlertController?
    var presentingViewController: UIViewController?
    var activityIndicator: UIActivityIndicatorView?
    var delegate:BusyAlertDelegate?
    var constrainX: NSLayoutConstraint?
    var constrainY: NSLayoutConstraint?
    
    init (title:String, message:String, presentingViewController: UIViewController) {
        busyAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        /*busyAlertController!.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel Button"), style: UIAlertActionStyle.Cancel, handler:{(alert: UIAlertAction!) in
            self.delegate?.didCancelBusyAlert()
        }))*/
        self.presentingViewController = presentingViewController
        //let _activityIndicator = ActivityIndicator(frame: CGRect(x: 0, y: 0, width: 50, height: 50))//UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        busyAlertController!.view.addSubview(activityIndicator!)
        activityIndicator?.center = CGPointMake(130, 25)
    }
    
    func display() {
        dispatch_async(dispatch_get_main_queue(), {
            
            self.presentingViewController!.presentViewController(self.busyAlertController!, animated: true, completion: {
                self.activityIndicator!.translatesAutoresizingMaskIntoConstraints = false
                //self.busyAlertController!.view.addConstraint(NSLayoutConstraint(item: self.activityIndicator!, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.busyAlertController!.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
                //self.busyAlertController!.view.addConstraint(NSLayoutConstraint(item: self.activityIndicator!, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.busyAlertController!.view, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
                self.activityIndicator!.startAnimating()
                
            })
        })
        
    }
    
    func finish() {
        
        dispatch_async(dispatch_get_main_queue()) {
            //sleep(2)
            self.activityIndicator?.removeFromSuperview()
            self.busyAlertController?.message = "Success complete"
            self.busyAlertController!.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Cancel Button"), style: UIAlertActionStyle.Cancel, handler:{(alert: UIAlertAction!) in
                self.delegate?.didCancelBusyAlert()
            }))
        }
    }
    
    func dismiss() {
        dispatch_async(dispatch_get_main_queue(), {
            self.busyAlertController?.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
}
