//
//  MoreTableViewController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/3/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class MoreTableViewController: UITableViewController {

    let cellIdentifier = "MoreViewCell"
    
    var items = ["MY ACOOUNT","CONTACT US","ABOUT US"]
    var icons = ["person_black_18p","chat_black_18p","info_black_18p"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MoreViewCell
        cell.label.text = items[indexPath.row]
        cell.icon.image = UIImage(named: icons[indexPath.row])
        return cell
    }
    
}
