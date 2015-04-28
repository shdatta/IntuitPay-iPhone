//
//  PayInformation.swift
//  IntuitPay
//
//  Created by Nanjappa, Srikanta on 4/27/15.
//  Copyright (c) 2015 Nanjappa, Srikanta. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class PayInformation : BaseProperties {
    
    var intuitId:String
    var accountNumber:String!
    var comments:String!
    var amount:String
    var cardId:String
    var pin:String?
    
    init(intuitId:String, accountNumber:String!, comments:String!, amount:String, cardId:String) {
        self.intuitId = intuitId
        self.accountNumber = accountNumber
        self.comments = comments
        self.amount = amount
        self.cardId = cardId
    }
    
    override  func getServerURL() -> String {
        return serverUrl + "sale"
    }
    
    override func getPostData() -> Dictionary<String, String>! {
        
        let appDel:AppDelegate = (UIApplication.sharedApplication().delegate) as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext!

        var params = [String: String](minimumCapacity: 5)
        params["phone_number"] = appDel.phone_info?.phone
        params["id"] = self.cardId
        params["amount"] = self.amount
        params["intuitId"] = self.intuitId
        params["pin"] = self.pin
        return params
    }
    
    override func validate(id:String) ->String{
        if id.isEmpty{
            return "Please select the card to pay with"
        }
        if intuitId.isEmpty{
            return "IntuitId cannot be empty"
        }
        if amount.isEmpty{
            return "PLease enter valid amount"
        }
        return ""
        
    }
}
