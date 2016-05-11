//
//  ItemDetailViewController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 1/19/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class ItemDetailViewController: BaseViewController {

    var brandItem: BrandItem?
    var itemPrice: PriceItem?
    
    @IBOutlet weak var productPhoto: UIImageView!
    @IBOutlet weak var addToCartPanel: UIView!
    @IBOutlet weak var specificationPanel: UIView!
    @IBOutlet weak var descriptionPanel: UITextView!
    @IBOutlet weak var pricePanel: UIView!
    
    @IBOutlet weak var longDescription: UITextView!
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var manufacturerLabel: UILabel!
    

    @IBOutlet weak var quantity: UILabel!
    
    var productPhotoImage: UIImage!
    var manufacturer: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addToCartPanel.layer.cornerRadius = 10
        addToCartPanel.layer.masksToBounds = true
        
        specificationPanel.layer.cornerRadius = 10
        specificationPanel.layer.masksToBounds = true
        
        descriptionPanel.layer.cornerRadius = 10
        descriptionPanel.layer.masksToBounds = true
        
        pricePanel.layer.cornerRadius = 8
        pricePanel.layer.masksToBounds = true
        
        productName.text = brandItem?.getName()
        
        let theAttributedString = try! NSAttributedString(data: brandItem!.longDescription.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!,
            options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil)
        longDescription.attributedText = theAttributedString
        
        self.productPrice.text = "CAD $ " + brandItem!.getPrice().definePrices
        self.productPhoto.image = self.productPhotoImage!
        self.manufacturerLabel.text = self.manufacturer!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func quantityChange(sender: UIStepper) {
        quantity.text = String(Int(sender.value))
    }
}
