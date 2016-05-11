//
//  ItemPageContentViewController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/1/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class ItemPageContentViewController: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource, BusyAlertDelegate {

    
    @IBOutlet var viewContainer: UIView!
    @IBOutlet var scrollView: UIScrollView!
    
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var property: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    
    var productOptions = [ProductOption]()
    var optionChoiceDictionary = [Int64:[ProductOptionChoice]]()
    //var choicedOption = [Int64:ProductOptionChoice]()
    var selectedOption = [Int64:ProductOptionChoice]()
    var textFields = [Int:UITextField]()
    
    var brandItem: BrandItem?
    
    var pageIndex: Int?
    
    var optionsCount: Int = 0
    var busyAlertController: BusyAlert?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.text = brandItem?.getName()
        price.text = OrderController.sharedInstance().getCurrentOrderCurrency() + " " + (brandItem?.getPrice().definePrices)!
        
        let url:NSURL =  NSURL(string: Constant.URL_IMAGE + brandItem!.defaultImageName)!
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let task = session.dataTaskWithRequest(request) { (let data, let response, let error) in
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                return
            }
            let image = UIImage(data: data!)
            dispatch_async(dispatch_get_main_queue(), {
                self.photo.image = image
            })
        }
        task.resume()
        
        if(brandItem!.getPrice().definePrices == "") {
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                // do some task
                PriceItem.getPriceBySKU((self.brandItem!.parentBrandItem?.getSKU())!, completeHandler: {(priceItem) in
                    self.brandItem!.setPrice(priceItem)
                    self.brandItem?.parentBrandItem?.setPrice(priceItem)
                    dispatch_async(dispatch_get_main_queue()) {
                        self.price.text = self.brandItem?.getPrice().definePrices
                    }
                })
            }
        }
        ProductVariationValue.GetProductVariationByProductID((brandItem?.ID)!, completeHandler: {(let productVariationValue) in
            ProductVariation.GetProductVariationByID(productVariationValue.getVariationID(), completeHandler: {(let productVariation) in
                dispatch_async(dispatch_get_main_queue()) {
                    self.property.text = productVariation.getName()
                }
            })
        })
        
        ProductOption().GetProductOption((brandItem?.parentID)!, completeHandler: {(productOptionList, message, error) in
            if error == nil {
                self.productOptions = productOptionList
                for option in self.productOptions {
                    //print("ProductOption : " + String(option.ID))
                    ProductOptionChoice().GetProductOptionChoice(option.ID, completeHandler: {(optionChoiceList, message, error) in
                        //print("ProductOptionChoice : " + String(option.ID))
                        if error == nil {
                            self.optionChoiceDictionary[option.ID] = optionChoiceList
                            dispatch_async(dispatch_get_main_queue()) {
                                self.createOptionView()
                            }
                        }
                    })
                }
            }
        })
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ItemPageContentViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ItemPageContentViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    @IBAction func addProductToCart(sender: AnyObject) {
        self.addToCartDialog()
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            scrollView.frame.size.height -= keyboardSize.height
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            scrollView.frame.size.height += keyboardSize.height
        }
    }
    
    private func createOptionView() {
        var tag: Int = 0;
        
        for option in self.productOptions {
            if option.type == 1 {
                var optionLabel = option.name + ": " 
                optionLabel += (option.isRequired) ? "*" : ""
                addNameView(0, y: 0, name: optionLabel)
                let lastView = self.getLastViewFrame()!
                let textField = TextFieldRightArrow(frame: CGRectMake(0, 0, 0,0))
                textField.borderStyle = UITextBorderStyle.RoundedRect
                textField.tag = tag
                textField.inputAccessoryView = toolBarButtonDone(tag)
                //textField.delegate = self
                self.viewContainer.addSubview(textField)
                self.addConstarain(textField, view: lastView, marginTop: 5.0)
                
                let pickerView = UIPickerView()
                pickerView.tag = tag
                pickerView.delegate = self
                pickerView.dataSource = self
                pickerView.showsSelectionIndicator = true
                textField.inputView = pickerView
                
                self.textFields[tag] = textField
            }
        }
        
        tag += 1
    }
    
    private func addNameView(x: CGFloat, y: CGFloat, name: String) -> CGFloat {
        let lastView = self.getLastViewFrame()
        
        let nameLabel: UILabel = UILabel()
        //nameLabel.frame = CGRectMake(x, y, self.view.frame.width - (x * 2), 30)
        nameLabel.frame = CGRectMake(0, 0, 0, 0)
        nameLabel.textColor = UIColor.grayColor()
        nameLabel.textAlignment = NSTextAlignment.Left
        nameLabel.font = nameLabel.font.fontWithSize(16)
        nameLabel.text = name
        nameLabel.numberOfLines = 0
        nameLabel.sizeToFit()
        nameLabel.frame.size = nameLabel.bounds.size
        //nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.viewContainer.addSubview(nameLabel)
        
        self.addConstarain(nameLabel, view: lastView!, marginTop: 5.0)
        return nameLabel.frame.height
    }
    
    private func getLastViewFrame() -> UIView? {
        var y: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        var retView: UIView?
        for view in self.viewContainer.subviews {
            let _y = view.frame.origin.y + view.frame.height
            if _y > y.origin.y {
                retView = view
            }
            y = view.frame
        }
        if retView == nil {
            retView = self.viewContainer
        }
        return retView
    }
    
    private func toolBarButtonDone(tag: Int) -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ItemPageContentViewController.donePicker(_:)))
        doneButton.tag = tag
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        return toolBar
    }
    
    // Picker delegate
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let tag = pickerView.tag
        let productOption = self.productOptions[tag]
        let count = (optionChoiceDictionary[productOption.ID]?.count)!
        if count == 0 {
            return 0
        }
        return (optionChoiceDictionary[productOption.ID]?.count)!
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let tag = pickerView.tag
        var optionChoice = self.optionChoiceDictionary[self.productOptions[tag].ID]
        self.selectedOption[self.productOptions[tag].ID] = optionChoice![row]
        var title = String()
        title.appendContentsOf(optionChoice![row].name)
        if optionChoice![row].priceDiff > 0 {
            let currency: String = OrderController.sharedInstance().getCurrentOrderCurrency()
            title.appendContentsOf(String("(+" + currency + " " + String(optionChoice![row].priceDiff!) + ")"))
        }
        return title//optionChoice![row].name
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var choiceOptions = self.optionChoiceDictionary[self.productOptions[pickerView.tag].ID]
        self.selectedOption[self.productOptions[pickerView.tag].ID] = choiceOptions![row]
        //self.navigationItem.rightBarButtonItem?.enabled = true
        self.textFields[pickerView.tag]?.text = choiceOptions![row].name
        if choiceOptions![row].priceDiff > 0 {
            let currency: String = OrderController.sharedInstance().getCurrentOrderCurrency()
            self.textFields[pickerView.tag]?.text?.appendContentsOf(String(" (+" + currency + " " + String(choiceOptions![row].priceDiff!) + ")"))
        }
        pickerView.resignFirstResponder()
    }
    
    
    func donePicker(sender: UIBarButtonItem) {
        //print("Done picker with tag = " + String(sender.tag))
        self.textFields[sender.tag]?.resignFirstResponder()
    }
    
    private func addConstarain(myView: UIView, view: UIView, marginTop: CGFloat) {
        myView.translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: myView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: marginTop).active = true
        NSLayoutConstraint(item: myView, attribute: .LeadingMargin, relatedBy: .Equal, toItem: self.viewContainer, attribute: .LeadingMargin, multiplier: 1.0,constant: 15).active = true
        NSLayoutConstraint(item: myView, attribute: .TrailingMargin, relatedBy: .Equal, toItem: self.viewContainer, attribute: .TrailingMargin, multiplier: 1.0, constant: -15).active = true
    }
    
    // BusyAlert delegate
    func didCancelBusyAlert() {
        print("Cancel busy alert")
    }
    
    var countUpdateOptions: Int = 0
    private func addToCartDialog() {
        if self.productOptions.count != self.selectedOption.count {
            let actionSheetController: UIAlertController = UIAlertController(title: "Warning", message: "Please complete required product options", preferredStyle: .Alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in}
            actionSheetController.addAction(cancelAction)
            self.presentViewController(actionSheetController, animated: true, completion: nil)
            return
        }
        if UserController.sharedInstance().isAnonimous() {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyBoard.instantiateViewControllerWithIdentifier("LoginNavigationController") as! UINavigationController
            self.presentViewController(viewController, animated: true, completion: nil)
            SessionController.sharedInstance().SetProduct(self.brandItem?.ID)
            SessionController.sharedInstance().SetOption(self.selectedOption)
        } else {
            let actionSheetController: UIAlertController = UIAlertController(title: "Add to cart", message: "Do you want add this product to your cart", preferredStyle: .Alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in}
            actionSheetController.addAction(cancelAction)
            
            //Create and an option action
            let yesAction: UIAlertAction = UIAlertAction(title: "Yes", style: .Default) { action -> Void in
                self.busyAlertController = BusyAlert(title: "", message: "", button: "OK", presentingViewController: self)
                self.busyAlertController?.delegate = self
                self.busyAlertController?.display()
                self.countUpdateOptions = self.selectedOption.count
                
                OrderController.sharedInstance().getCurrentOrder()?.addProductToCart((self.brandItem?.ID)!, completeHandler: {(orderedItem, message, error) in
                    if orderedItem.count > 0 {
                        if self.selectedOption.count > 0 {
                            for item in self.selectedOption {
                                OrderedItemOption().SetOrderedItemOption(orderedItem[0].ID, productOptionChoice: item.1.ID, optionText: nil, completeHandler: {(options, message, error) in
                                    self.countUpdateOptions -= 1
                                    if message != nil {
                                        print(" message : " + message! + " " + String(self.countUpdateOptions))
                                    }
                                    if self.countUpdateOptions == 0 {
                                        print("Update Order ")
                                        OrderController.sharedInstance().UpdateUserOrder(UserController.sharedInstance().getUser()!.ID, completeHandler: {(successInit) in
                                            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                                            LiveCartController.TabBarUpdateBadgeValue((appDelegate.window?.rootViewController as! UITabBarController))
                                            self.busyAlertController!.dismiss()
                                        })
                                    }
                                })
                            }
                        } else {
                            OrderController.sharedInstance().UpdateUserOrder(UserController.sharedInstance().getUser()!.ID, completeHandler: {(successInit) in
                                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                                LiveCartController.TabBarUpdateBadgeValue((appDelegate.window?.rootViewController as! UITabBarController))
                                self.busyAlertController!.dismiss()
                            })
                        }
                    } else {
                        OrderController.sharedInstance().UpdateUserOrder(UserController.sharedInstance().getUser()!.ID, completeHandler: {(successInit) in
                            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                            LiveCartController.TabBarUpdateBadgeValue((appDelegate.window?.rootViewController as! UITabBarController))
                            self.busyAlertController!.dismiss()
                        })
                    }
                    
                    /*OrderController.sharedInstance().UpdateUserOrder(UserController.sharedInstance().getUser()!.ID, completeHandler: {(successInit) in
                        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        LiveCartController.TabBarUpdateBadgeValue((appDelegate.window?.rootViewController as! UITabBarController))

                    })*/
                })
            }
            actionSheetController.addAction(yesAction)
            self.presentViewController(actionSheetController, animated: true, completion: nil)
        }
    }
}
