//
//  SerchViewController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 3/3/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class SerchViewController: UITableViewController, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    var searchController : UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchController = UISearchController(searchResultsController:  nil)
        
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = true
        
        //self.navigationItem.titleView = searchController.searchBar
        
        self.definesPresentationContext = false
        
        self.tableView.tableHeaderView = searchController.searchBar
        
        self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancel:"), animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func cancel(target: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
    }
}
