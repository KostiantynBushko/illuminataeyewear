//
//  ProductOptionViewController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 3/31/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit

class ProductOptionViewController: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, BusyAlertDelegate {

    private var HEIGHT_BETWEN_OPTIONS: CGFloat = 15
    private var START_ELEMENT_X: CGFloat = 10
    private var START_ELEMENT_Y: CGFloat = 10
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var viewContainer: UIView!
    @IBOutlet var name: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    
    
    var brandItem: BrandItem?
    var orderProductItem: OrderProductItem?
    
    var productOptions = [ProductOption]()
    var optionChoiceDictionary = [Int64:[ProductOptionChoice]]()
    var textFields = [Int:UITextField]()
    var selectedOption = [Int64:ProductOptionChoice]()
    var optionTexts = [Int64:String]()
    
    var closeHandler:((Bool) ->Void)?
    
    var needUpdateOrder: Bool = false
    
    var busyAlertController: BusyAlert?
    var IAgreeTermsService: Bool = true
    
    var viewSuccessLoaded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(ProductOptionViewController.cancel(_:))), animated: true)
        
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(title: "Save", style: .Plain, target: self, action: #selector(ProductOptionViewController.save(_:))), animated: true)
        //let save: UIBarButtonItem
        let info: UIBarButtonItem = UIBarButtonItem(image:UIImage(named:"ic_info_outline_18p"), style: .Plain, target:self, action:#selector(ItemPageViewController.productInfo(_:)))
        
        //self.navigationItem.setRightBarButtonItems([wish,info], animated: true)
        self.navigationItem.rightBarButtonItems?.append(info)
        
        self.navigationItem.rightBarButtonItem?.enabled = false
        viewContainer.autoresizesSubviews = true
    
        
        if brandItem != nil {
            
            self.name.text = self.brandItem?.getName()
            var productID = Int64()
            if (self.brandItem?.parentBrandItem != nil) {
                productID = (self.brandItem?.parentBrandItem?.ID)!
            } else {
                productID = (self.brandItem?.ID)!
            }
            ProductOption().GetProductOption(productID, completeHandler: {(options, message, error) in
                if options.count == 0 {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.createView()
                        self.addDescriptionView(0, y: 0, description: "This product does not contain any specific options for choice")
                    }
                } else {
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
                }
            })
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BrandItemViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BrandItemViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
                swButton.setOn(true, animated: false)
                swButton.addTarget(self, action: #selector(ProductOptionViewController.setTermsService(_:)), forControlEvents: UIControlEvents.ValueChanged)
                
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
                
            } else if item.type == 1 {
                
                var optionLabel = item.name + ": "
                optionLabel += (item.isRequired) ? "*" : ""
                y += addNameView(x,y: y, name: optionLabel)
                
                lastView = self.getLastViewFrame()!
                y += 5
                let textField = TextFieldRightArrow(frame: CGRectMake(x, y, self.view.frame.width - (x * 2), 30))
                textField.borderStyle = UITextBorderStyle.RoundedRect
                textField.tag = tag
                textField.inputAccessoryView = toolBarButtonDone(tag)
                textField.delegate = self
                self.viewContainer.addSubview(textField)
                
                self.addConstarain(textField, view: lastView, marginTop: 10.0)
                
                y += textField.frame.height
                
                let pickerView = UIPickerView()
                pickerView.tag = tag
                pickerView.delegate = self
                pickerView.dataSource = self
                pickerView.showsSelectionIndicator = true
                textField.inputView = pickerView
                
                let count = optionChoiceDictionary.count
                if count > 0 {
                    for optionChoice in optionChoiceDictionary[item.ID]! {
                        for orderedItem in self.orderProductItem!.orderedItemOptionsList {
                            if orderedItem.choiceID == optionChoice.ID {
                                if item.type == 1 {
                                    //title.appendContentsOf(String("(+" + currency + " " + String(optionChoice![row].priceDiff!) + ")"))
                                    textField.text = optionChoice.name
                                    if optionChoice.priceDiff > 0 {
                                        let currency: String = OrderController.sharedInstance().getCurrentOrderCurrency()
                                        textField.text?.appendContentsOf(String(" (+" + currency + " " + String(optionChoice.priceDiff!) + ")"))
                                    }
                                    
                                } else {
                                    textField.text = orderedItem.optionText
                                }
                                break
                            }
                        }
                        if (!textField.text!.isEmpty) {
                            break
                        }
                    }
                }
                
                self.textFields[tag] = textField
                
                if !item.description.isEmpty {
                    y += addDescriptionView(x, y: y, description: item.description)
                    y += 5
                }
                
                
            } else if item.type == 2 {
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
                
                let count = optionChoiceDictionary.count
                if count > 0 {
                    for optionChoice in optionChoiceDictionary[item.ID]! {
                        for orderedItem in self.orderProductItem!.orderedItemOptionsList {
                            if orderedItem.choiceID == optionChoice.ID {
                                if item.type == 1 {
                                    //title.appendContentsOf(String("(+" + currency + " " + String(optionChoice![row].priceDiff!) + ")"))
                                    textField.text = optionChoice.name
                                    if optionChoice.priceDiff > 0 {
                                        let currency: String = OrderController.sharedInstance().getCurrentOrderCurrency()
                                        textField.text?.appendContentsOf(String(" (+" + currency + " " + String(optionChoice.priceDiff!) + ")"))
                                    }
                                    
                                } else {
                                    textField.text = orderedItem.optionText
                                }
                                break
                            }
                        }
                        if (!textField.text!.isEmpty) {
                            break
                        }
                    }
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
        self.viewSuccessLoaded = true
        self.activityIndicator.stopAnimating()
        self.scrollView.hidden = false
        
        /*let lastViewFrame = getLastViewFrame()!
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: (lastViewFrame.frame.height) + (lastViewFrame.frame.origin.y))
        self.viewContainer.frame.size.height = (lastViewFrame.frame.height) + (lastViewFrame.frame.origin.y)*/
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
        dynamicLabel.textAlignment = NSTextAlignment.Center
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
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ProductOptionViewController.donePicker(_:)))
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
        return title //optionChoice![row].name
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
    
    // Text field delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //print(" : " + textField.text!)
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        //print("TextField end editing : " + textField.text!)
        self.navigationItem.rightBarButtonItem?.enabled = true
        if self.productOptions[textField.tag].type == 2 {
            var choiceOptions = self.optionChoiceDictionary[self.productOptions[textField.tag].ID]
            //print(choiceOptions?.count)
            self.selectedOption[self.productOptions[textField.tag].ID] = choiceOptions![0]
            self.optionTexts[choiceOptions![0].ID] = textField.text
        }
        return true
    }


    func donePicker(sender: UIBarButtonItem) {
        //print("Done picker with tag = " + String(sender.tag))
        self.textFields[sender.tag]?.resignFirstResponder()
    }
    
    func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        if closeHandler != nil {
            closeHandler!(needUpdateOrder)
        }
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
    
    var countUpdateOptions: Int = 0
    func save(sender: AnyObject) {
        countUpdateOptions = selectedOption.count
        //print("Add to cart")
        for field in self.textFields {
            if field.1.text!.isEmpty && self.productOptions[field.1.tag].isRequired {
                let actionSheetController: UIAlertController = UIAlertController(title: "Warning", message: "Please complete all field", preferredStyle: .Alert)
                let cancelAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Cancel) { action -> Void in}
                actionSheetController.addAction(cancelAction)
                self.presentViewController(actionSheetController, animated: true, completion: nil)
                return
            }
        }
        
        if self.IAgreeTermsService == false {
            let actionSheetController: UIAlertController = UIAlertController(title: "Warning", message: "You must agree with terms of service", preferredStyle: .Alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Cancel) { action -> Void in}
            actionSheetController.addAction(cancelAction)
            self.presentViewController(actionSheetController, animated: true, completion: nil)
            return
        }
        
        busyAlertController = BusyAlert(title: "", message: "", button: "OK", presentingViewController: self)
        busyAlertController?.delegate = self
        busyAlertController?.display()
        
        for item in selectedOption {
            //print(item.1)
            var optionText: String?
            for option in self.productOptions {
                if option.ID == item.0 {
                    //print("Selected Option type = " + String(option.type))
                    optionText = self.optionTexts[item.1.ID]
                }
            }
            OrderedItemOption().SetOrderedItemOption((self.orderProductItem?.ID)!, productOptionChoice: item.1.ID, optionText: optionText, completeHandler: {(options, message, error) in
                self.countUpdateOptions -= 1
                if message != nil {
                    print(" message : " + message! + " " + String(self.countUpdateOptions))
                }
                if self.countUpdateOptions == 0 {
                    print("Update Order ")
                    OrderController.sharedInstance().UpdateUserOrder((UserController.sharedInstance().getUser()?.ID)!, completeHandler: {(success) in
                        self.busyAlertController?.message = "Success"
                        self.busyAlertController!.finish()
                    })
                }
            })
            /*OrderedItemOption().SetOrderedItemOption((self.orderProductItem?.ID)!, productOptionChoice: item.1,optionText: nil, completeHandler: {(options, message, error) in
                self.countUpdateOptions -= 1
                if message != nil {
                    self.needUpdateOrder = true
                    print(" message : " + message! + " " + String(self.countUpdateOptions))
                }
                if self.countUpdateOptions == 0 {
                    print("Update Order ")
                    OrderController.sharedInstance().UpdateUserOrder((UserController.sharedInstance().getUser()?.ID)!, completeHandler: {(success) in
                        self.busyAlertController?.message = "Success"
                        self.busyAlertController!.finish()
                    })
                }
            })*/
        }
    }
    func didCancelBusyAlert() {
        print("Cancel busy alert")
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
    
    private func addConstarain(myView: UIView, view: UIView, marginTop: CGFloat) {
        myView.translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: myView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: marginTop).active = true
        NSLayoutConstraint(item: myView, attribute: .LeadingMargin, relatedBy: .Equal, toItem: self.viewContainer, attribute: .LeadingMargin, multiplier: 1.0,constant: 15).active = true
        NSLayoutConstraint(item: myView, attribute: .TrailingMargin, relatedBy: .Equal, toItem: self.viewContainer, attribute: .TrailingMargin, multiplier: 1.0, constant: -15).active = true
    }
    
    func productInfo(sender: AnyObject) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyBoard.instantiateViewControllerWithIdentifier("ProductInfoNavigationController") as! UINavigationController
        self.presentViewController(navigationController, animated: true, completion: nil)
        let productInfoViewController = navigationController.viewControllers.first as! ProductInfoViewController
        productInfoViewController.brandItem = self.brandItem
    }
    
}







