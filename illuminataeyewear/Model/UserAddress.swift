//
//  Address.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/5/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import Foundation

class UserAddress: BaseModel {
    
    private var ID = Int32()
    private var stateID = Int32()
    private var eavObjectID = Int32()
    private var firstName = String()
    private var lastName = String()
    private var companyName = String()
    private var address = String()
    private var address2 = String()
    private var city = String()
    private var stateName = String()
    private var postalCode = String()
    private var countryID = String()
    private var phone = String()
    
    func setID(ID: Int32) { self.ID = ID }
    func setStateID(stateID: Int32) { self.stateID = stateID }
    func setEavObject(eavObjectID: Int32) { self.eavObjectID = eavObjectID }
    func setFirstName(firstName: String) { self.firstName = firstName }
    func setLastName(lastName: String) { self.lastName = lastName }
    func setCompanyName(companyName: String) { self.companyName = companyName }
    func setAddress(address: String) { self.address = address }
    func setAddressTwo(address2: String) { self.address2 = address2 }
    func setCity(city: String) { self.city = city }
    func setStateName(stateName: String) { self.stateName = stateName }
    func setPostalCode(postalCode: String) { self.postalCode = postalCode }
    func setCountryID(countryID: String) { self.countryID = countryID }
    func setPhone(phone: String) { self.phone = phone }
    
    
    func getID() -> Int32 { return self.ID }
    func getStateID() -> Int32 { return self.stateID }
    func getEavObject() -> Int32 { return self.eavObjectID }
    func getFirstName() -> String { return self.firstName }
    func getLastName() -> String { return self.lastName }
    func getCompanyName() -> String { return self.companyName }
    func getAddres() -> String { return self.address }
    func getAddressTwo() -> String { return self.address2 }
    func getCity() -> String { return self.city }
    func getStateName() -> String { return self.stateName }
    func getPostalCode() -> String { return self.postalCode }
    func getCountryID() -> String { return self.countryID }
    func getPhone() -> String { return self.phone }

    
    override func getXML(id: Int32) -> String {
        return "<ID>"  + String(id) + "</ID>"
            + "<stateID>" + String(self.stateID) + "</stateID>"
            + "<firstName>" + self.firstName + "</firstName>"
            + "<lastName>" + self.lastName + "</lastName>"
            + "<companyName>" + self.companyName + "</companyName>"
            + "<address1>" + self.address + "</address1>"
            + "<address2>" + self.address2 + "</address2>"
            + "<city>" + self.city + "</city>"
            + "<stateName>" + self.stateName + "</stateName>"
            + "<postalCode>" + self.postalCode + "</postalCode>"
            + "<countryID>" + self.countryID + "</countryID>"
            + "<phone>" + self.phone + "</phone>"
    }
    
    func updateUdress(params: String, completeHandler: (UserAddress) -> Void) {
        let url: NSURL = NSURL(string: Constant.URL_BASE_API)!
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let parameters = "xml=<user_address><update>" +  params + "</update></user_address>"
        request.HTTPBody = parameters.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request, completionHandler: {(let data, let response, let error) in
            guard let _:NSData = data, let _:NSURLResponse = response where error == nil else {
                return
            }
            XmlUserAddressParser().ParseUserAddress(data!, completeHandler: {(userAddress) in
                completeHandler(userAddress)
            })
        })
        task.resume()
    }
    
    func GetAddressByID(ID: Int64, completeHandler: (UserAddress) -> Void) {
        let url: NSURL = NSURL(string: Constant.URL_BASE_API)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let parameters = "xml=<user_address><list><ID>" + String(ID) + "</ID></list></user_address>"
        request.HTTPBody = parameters.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request, completionHandler: {(let data, let response, let error) in
            guard let _:NSData = data, let _:NSURLResponse = response where error == nil else {
                return
            }
            XmlUserAddressParser().ParseUserAddress(data!, completeHandler: {(userAddress) in
                completeHandler(userAddress)
            })
        })
        task.resume()
    }
    
}
