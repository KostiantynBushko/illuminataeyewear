//
//  BrandTableViewController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 1/13/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit
import Foundation
import CoreData


class BrandTableViewController: BaseTableViewController, NSXMLParserDelegate {
    
    // MARK: Properties
    
    var brands = [Brand]()
    var lenses: Brand?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Brand.GetBrands({(brands) in
            self.brands = brands
            var i = Int()
            for b in brands {
                if b.ID == 267 {
                    self.lenses = b
                    self.brands.removeAtIndex(i)
                    break
                }
                i += 1
            }
            self.RefreshTable()
        })
    }
    
    // MARK: Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if lenses != nil {
                return 1
            }
            return 0
        } else if section == 1 {
            return brands.count;
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("SimpleViewCell", forIndexPath: indexPath) as! SimpleViewCell
            cell.label.text = "Rx Lenses"
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("BrandViewCell", forIndexPath: indexPath) as! BrandViewCell
            let brand = brands[indexPath.row]
            cell.brandName.text = brand.name
            cell.number.text = String(indexPath.row)
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        } else if indexPath.section == 1{
            return 60
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let brandItemsTableViewController = storyBoard.instantiateViewControllerWithIdentifier("ItemsBrandTableViewController") as! ItemsBrandTableViewController
        if indexPath.section == 0 {
            if self.lenses != nil {
                brandItemsTableViewController.brand = self.lenses
            }
        } else {
            brandItemsTableViewController.brand = brands[indexPath.row]
        }
        self.navigationController?.pushViewController(brandItemsTableViewController, animated: true)
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Our Glasses Brands"
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 40
        }
        return 0
    }
    
    /*override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor
    }*/
    
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showBrandItemsTableView") {
            let brandItemsTableViewController = segue.destinationViewController as! ItemsBrandTableViewController
            if let indexPath : NSIndexPath = self.tableView.indexPathForSelectedRow! {
                brandItemsTableViewController.brand = brands[indexPath.row]
            }
        }
    }*/
    
    
    func RefreshTable() {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            return
        })
    }
}





















