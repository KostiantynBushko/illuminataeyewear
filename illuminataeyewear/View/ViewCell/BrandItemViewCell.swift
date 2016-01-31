//
//  BrandItemViewCell.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 1/13/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class BrandItemViewCell: UITableViewCell {

    // MARK: Properties
    var brandItem: BrandItem?
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var number: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func getDataModelObject() -> BrandItem {
        brandItem = BrandItem()
        brandItem?.image = self.photo.image
        brandItem?.name = self.name.text!
        return brandItem!
    }
    
    @IBAction func addItemToWishList(sender: UIButton) {
        let wishItem = WishItem(productID: String((brandItem?.ID)!))
        DBWishProductTable.AddItemToWishList(wishItem!)
    }
}
