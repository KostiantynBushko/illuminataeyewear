//
//  BrandItemViewController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 4/4/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class BrandItemViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate, BusyAlertDelegate {

    private var HEIGHT_BETWEN_OPTIONS: CGFloat = 15
    private var START_ELEMENT_X: CGFloat = 10
    private var START_ELEMENT_Y: CGFloat = 10
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var photo: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var price: RoundRectLabel!
    @IBOutlet var scrollView: UIScrollView!
   
    @IBOutlet var viewContainer: UIView!
    
    var brandItem: BrandItem?
    
    var productOptions = [ProductOption]()
    var optionChoiceDictionary = [Int64:[ProductOptionChoice]]()
    var textFields = [Int:UITextField]()
    var selectedOption = [Int64:ProductOptionChoice]()
    var optionTexts = [Int64:String]()
    
    var busyAlertController: BusyAlert?
    var IAgreeTermsService: Bool = false
    
    var viewSuccessLoaded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewContainer.autoresizesSubviews = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
        self.price.text = OrderController.sharedInstance().getCurrentOrderCurrency() + " 0.00"
        if brandItem != nil {
            brandItem?.getDefaultImage({(success) in
                if success {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.photo.image = self.brandItem?.getImage()
                    }
                }
            })
            self.price.text = OrderController.sharedInstance().getCurrentOrderCurrency() + " " + ((brandItem?.getPrice())?.definePrices)!
            self.name.text = brandItem?.getName()
            
            ProductOption().GetProductOption((brandItem?.ID)!, completeHandler: {(options, message, error) in
                self.productOptions = options
                for productOption in self.productOptions {
                    ProductOptionChoice().GetProductOptionChoice(productOption.ID, completeHandler: {(optionChoice, message, error) in
                        if error == nil {
                            self.optionChoiceDictionary[optionChoice[0].optionID] = optionChoice
                            if self.optionChoiceDictionary.count == self.productOptions.count {
                                dispatch_async(dispatch_get_main_queue()) {
                                    self.createView()
                                }
                            }
                        }
                    })
                }
            })
        }
        START_ELEMENT_Y += HEIGHT_BETWEN_OPTIONS * 2
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func createView() {
        if self.viewSuccessLoaded {
            return
        }
        var y: CGFloat = START_ELEMENT_Y
        let x: CGFloat = START_ELEMENT_X
        var lastView = UIView()
        
        var tag: Int = 0;
        for item in productOptions {
            //print(optionChoiceDictionary)
            if item.type == 0 {
                lastView = self.getLastViewFrame()!
                
                var optionLabel = item.name + ": "
                optionLabel += (item.isRequired) ? "*" : ""
                y += addNameView(x,y: y, name: optionLabel)
                lastView = self.getLastViewFrame()!
                
                let swButton: UISwitch = UISwitch(frame: CGRectMake(x, y, 0,0))
                self.viewContainer.addSubview(swButton)
                swButton.frame = CGRectMake(self.view.frame.width - swButton.frame.width - START_ELEMENT_X, y, 0, 0)
                swButton.tag = tag
                swButton.setOn(false, animated: false)
                swButton.addTarget(self, action: "setTermsService:", forControlEvents: UIControlEvents.ValueChanged)
                
                //self.addConstarain(swButton, view: lastView, marginTop: 10.0)
                swButton.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint(item: swButton, attribute: .Top, relatedBy: .Equal, toItem: lastView, attribute: .Bottom, multiplier: 1.0, constant: 5.0).active = true
                NSLayoutConstraint(item: swButton, attribute: .TrailingMargin, relatedBy: .Equal, toItem: self.viewContainer, attribute: .TrailingMargin, multiplier: 1.0, constant: -15).active = true
                
                y += swButton.frame.height
                y += 5
                if !item.description.isEmpty {
                    y += addDescriptionView(x, y: y, description: item.description)
                    y += 5
                }
                
            } else if item.type == 1 || item.type == 2 {
                
                var optionLabel = item.name + ": "
                optionLabel += (item.isRequired) ? "*" : ""
                y += addNameView(x,y: y, name: optionLabel)
                lastView = self.getLastViewFrame()!
                y += 5
                let textField = UITextField(frame: CGRectMake(x, y, self.view.frame.width - (x * 2), 30))
                textField.borderStyle = UITextBorderStyle.RoundedRect
                textField.tag = tag
                textField.inputAccessoryView = toolBarButtonDone(tag)
                textField.delegate = self
                self.viewContainer.addSubview(textField)
                
                self.addConstarain(textField, view: lastView, marginTop: 10.0)
                
                y += textField.frame.height
                
                if item.type == 1 {
                    let pickerView = UIPickerView()
                    pickerView.tag = tag
                    pickerView.delegate = self
                    pickerView.dataSource = self
                    pickerView.showsSelectionIndicator = true
                    textField.inputView = pickerView
                }
                
                self.textFields[tag] = textField
                
                if !item.description.isEmpty {
                    y += addDescriptionView(x, y: y, description: item.description)
                    y += 5
                }
                
                
            } else if item.type == 4 {
                lastView = self.getLastViewFrame()!
                let dynamicLabel: UILabel = UILabel()
                dynamicLabel.frame = CGRectMake(x, y, self.view.frame.width - (x * 2), 30)
                dynamicLabel.backgroundColor = UIColor(red: 200 / 255, green: 103 / 255, blue: 255 / 255, alpha: 1)
                dynamicLabel.textColor = UIColor.whiteColor()
                dynamicLabel.textAlignment = NSTextAlignment.Center
                dynamicLabel.font = dynamicLabel.font.fontWithSize(18)
                dynamicLabel.text = item.name
                self.viewContainer.addSubview(dynamicLabel)
                y += dynamicLabel.frame.height
                self.addConstarain(dynamicLabel, view: lastView, marginTop: 10.0)
            }
            
            y += HEIGHT_BETWEN_OPTIONS
            tag += 1
        }
        
        lastView = self.getLastViewFrame()!
        let buyButton = RoundRectButton(frame: CGRectMake(x, y, 100, 30))
        buyButton.setTitle("Add to Cart", forState: .Normal)
        buyButton.backgroundColor = UIColor(red: 0, green: 209.0/255, blue: 56.0/255.0, alpha: 1)
        buyButton.tintColor = UIColor.whiteColor()
        buyButton.setImage(UIImage(named: "cart_white_24p"), forState: .Normal)
        buyButton.frame.size.height = 80
        buyButton.addTarget(self, action: "addToCart:", forControlEvents: .TouchUpInside)
        self.viewContainer.addSubview(buyButton)
        
        self.addConstarain(buyButton, view: lastView, marginTop: 20.0)
        self.viewSuccessLoaded = true
        self.activityIndicator.stopAnimating()
        self.scrollView.hidden = false
        
        /*let lastViewFrame = getLastViewFrame()!
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: (lastViewFrame.frame.height) + (lastViewFrame.frame.origin.y) + 250)
        self.viewContainer.frame.size.height = (lastViewFrame.frame.height) + (lastViewFrame.frame.origin.y) + 250*/
    }


    private func addNameView(x: CGFloat, y: CGFloat, name: String) -> CGFloat {
        let lastView = self.getLastViewFrame()
        
        let nameLabel: UILabel = UILabel()
        nameLabel.frame = CGRectMake(x, y, self.view.frame.width - (x * 2), 30)
        nameLabel.textColor = UIColor.grayColor()
        nameLabel.textAlignment = NSTextAlignment.Left
        nameLabel.font = nameLabel.font.fontWithSize(18)
        nameLabel.text = name
        nameLabel.numberOfLines = 0
        nameLabel.sizeToFit()
        nameLabel.frame.size = nameLabel.bounds.size
        //nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.viewContainer.addSubview(nameLabel)
        
        self.addConstarain(nameLabel, view: lastView!, marginTop: 10.0)
        return nameLabel.frame.height
    }
    
    private func addDescriptionView(x: CGFloat, y: CGFloat, description: String) -> CGFloat {
        let lastView = self.getLastViewFrame()
        
        let dynamicLabel: UILabel = UILabel()
        dynamicLabel.frame = CGRectMake(x, y, self.view.frame.width - (x * 2), 18)
        dynamicLabel.textColor = UIColor.grayColor()
        dynamicLabel.textAlignment = NSTextAlignment.Left
        dynamicLabel.font = dynamicLabel.font.fontWithSize(13)
        dynamicLabel.text = description
        dynamicLabel.numberOfLines = 0
        dynamicLabel.sizeToFit()
        dynamicLabel.frame.size = dynamicLabel.bounds.size
        //dynamicLabel.translatesAutoresizingMaskIntoConstraints = false
        self.viewContainer.addSubview(dynamicLabel)
        
        self.addConstarain(dynamicLabel, view: lastView!, marginTop: 5.0)
        return dynamicLabel.frame.height
    }
    
    private func toolBarButtonDone(tag: Int) -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("donePicker:"))
        doneButton.tag = tag
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        return toolBar
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
    
    // Text field delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        print("TextField end editing : " + textField.text!)
        if self.productOptions[textField.tag].type == 2 {
            var choiceOptions = self.optionChoiceDictionary[self.productOptions[textField.tag].ID]
            print(choiceOptions?.count)
            self.selectedOption[self.productOptions[textField.tag].ID] = choiceOptions![0]
            self.optionTexts[choiceOptions![0].ID] = textField.text
        }
        return true
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
    
    func setTermsService(sender: UISwitch) {
        self.IAgreeTermsService = sender.on
        if sender.on {
            var choiceOptions = self.optionChoiceDictionary[self.productOptions[sender.tag].ID]
            self.selectedOption[self.productOptions[sender.tag].ID] = choiceOptions![0]
        } else {
            self.selectedOption.removeValueForKey(self.productOptions[sender.tag].ID)
        }
    }
    
    func didCancelBusyAlert() {
        print("Cancel busy alert")
    }
    
    private func addConstarain(myView: UIView, view: UIView, marginTop: CGFloat) {
        myView.translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: myView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: marginTop).active = true
        NSLayoutConstraint(item: myView, attribute: .LeadingMargin, relatedBy: .Equal, toItem: self.viewContainer, attribute: .LeadingMargin, multiplier: 1.0,constant: 15).active = true
        NSLayoutConstraint(item: myView, attribute: .TrailingMargin, relatedBy: .Equal, toItem: self.viewContainer, attribute: .TrailingMargin, multiplier: 1.0, constant: -15).active = true
    }
    
    var countUpdateOptions: Int = 0
    func addToCart(sender: AnyObject) {
        print("Add to cart")
        let countSelectedOption = self.selectedOption.count
        let countOption = self.productOptions.count
        print("selected: " + String(countSelectedOption) + " options: " + String(countOption))
        
        for field in self.textFields {
            if field.1.text!.isEmpty && self.productOptions[field.1.tag].isRequired{
                //busyAlertController?.message = "Please complete all field"
                //busyAlertController!.finish()
                let actionSheetController: UIAlertController = UIAlertController(title: "Warning", message: "Please complete all field", preferredStyle: .Alert)
                let cancelAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Cancel) { action -> Void in}
                actionSheetController.addAction(cancelAction)
                self.presentViewController(actionSheetController, animated: true, completion: nil)
                return
            }
        }
        
        if self.IAgreeTermsService == false {
            //busyAlertController?.message = "You must agree with terms of service"
            //busyAlertController!.finish()
            let actionSheetController: UIAlertController = UIAlertController(title: "Warning", message: "You must agree with terms of service", preferredStyle: .Alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Cancel) { action -> Void in}
            actionSheetController.addAction(cancelAction)
            self.presentViewController(actionSheetController, animated: true, completion: nil)
            return
        }
        
        //busyAlertController?.message = "Succes check"
        //busyAlertController!.finish()
        
        if UserController.sharedInstance().isAnonimous() {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyBoard.instantiateViewControllerWithIdentifier("LoginNavigationController") as! UINavigationController
            self.presentViewController(viewController, animated: true, completion: nil)
            SessionController.sharedInstance().SetProduct(self.brandItem?.ID)
            SessionController.sharedInstance().SetOption(self.selectedOption)
            var optionsText = [Int64:String]()
            for item in self.selectedOption {
                print(item.1)
                for option in self.productOptions {
                    if option.ID == item.0 {
                        //print("Selected Option type = " + String(option.type) + " " + String(self.optionTexts[item.1.ID]))
                        optionsText[item.1.ID] = self.optionTexts[item.1.ID]
                    }
                }
            }
            SessionController.sharedInstance().SetOptionText(optionsText)
            return
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
                        for item in self.selectedOption {
                            print(item.1)
                            var optionText: String?
                            for option in self.productOptions {
                                if option.ID == item.0 {
                                    //print("Selected Option type = " + String(option.type))
                                    optionText = self.optionTexts[item.1.ID]
                                }
                            }
                            OrderedItemOption().SetOrderedItemOption(orderedItem[0].ID, productOptionChoice: item.1.ID, optionText: optionText, completeHandler: {(options, message, error) in
                                self.countUpdateOptions -= 1
                                if message != nil {
                                    print(" message : " + message! + " " + String(self.countUpdateOptions))
                                }
                                if self.countUpdateOptions == 0 {
                                    //print("Update Order ")
                                    
                                    OrderController.sharedInstance().UpdateUserOrder(UserController.sharedInstance().getUser()!.ID, completeHandler: {(successInit) in
                                        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                                        LiveCartController.TabBarUpdateBadgeValue((appDelegate.window?.rootViewController as! UITabBarController))
                                        self.busyAlertController!.dismiss()
                                    })
                                }
                            })
                        }
                    } else {
                        self.busyAlertController!.dismiss()
                    }
                })
            }
            actionSheetController.addAction(yesAction)
            self.presentViewController(actionSheetController, animated: true, completion: nil)
        }
    }
}








