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


class BrandTableViewController: UITableViewController, NSXMLParserDelegate {
    
    // MARK: Properties
    
    var brands = [Brand]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getBrand()
    }
    
    // MARK: Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return brands.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "BrandViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! BrandViewCell
        
        let brand = brands[indexPath.row]
        
        cell.brandName.text = brand.brandName
        cell.number.text = String(indexPath.row)
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showBrandItemsTableView") {
            let brandItemsTableViewController = segue.destinationViewController as! ItemsBrandTableViewController
            //let cell = sender as! BrandViewCell
            
            /*if let indexPath = self.tableView.indexPathForCell(sender as! BrandViewCell) {
                brandItemsTableViewController.brand = brands[indexPath]  //cell.getDataModelObject()
            }*/
            if let indexPath : NSIndexPath = self.tableView.indexPathForSelectedRow! {
                brandItemsTableViewController.brand = brands[indexPath.row]
            }
            
        }
    }
    
    
    
    /***********************************************************************************************************/
    // Make http request to get brand list
    /***********************************************************************************************************/
    func getBrand() {
        
        let url:NSURL = NSURL(string: "http://www.illuminataeyewear.ca/api/xml")!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let paramString = "xml=<category><filter><parentNodeID>107</parentNodeID></filter></category>"
        request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) {(
            let data, let response, let error) in
            
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                print("error ")
                return
            }
            
            let dataString = (NSString(data: data!, encoding: NSUTF8StringEncoding) as! String).htmlDecoded()
            print(dataString)
            self.beginParse(data!)
        }
        task.resume()
    }
    
    /***********************************************************************************************************/
    // Implement xml parser interface to parce Brand data from xml request
    /***********************************************************************************************************/
    var xmlParser = NSXMLParser()
    var element = NSString()
    var currentBrand: String = ""
    var ID = NSString()
    var isEnabled: Bool = false
    
    func beginParse(xmlData: NSData) {
        xmlParser = NSXMLParser(data: xmlData)
        xmlParser.delegate = self
        xmlParser.parse()
    }

    var i = 0
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        element = elementName
        if (elementName as NSString).isEqualToString("category") {
            print("found category \(i)")
            i += 1
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if element == "name" {
            currentBrand += string
            //print("element \(i) " + string + " brands cound = " + String(brands.count))
        } else if element == "isEnabled" {
            if (string as NSString).isEqualToString("1") {
                isEnabled = true
            }
        } else if element == "ID" {
            ID = (string as NSString)
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqualToString("response") {
            print("End parse")
            RefreshTable()
        } else if (elementName as NSString).isEqualToString("category") {
            if isEnabled {
                brands.append(Brand(brandName: currentBrand.htmlDecoded(), categoryId: (ID as String))!)
                currentBrand = ""
            }
            isEnabled = false
        }
    }
    
    func RefreshTable() {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            return
        })
    }
}





















