//
//  Persistance.swift
//  IntuitPay
//
//  Created by Nanjappa, Srikanta on 4/23/15.
//  Copyright (c) 2015 Nanjappa, Srikanta. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Persistence {

    var appDel:AppDelegate
    var context:NSManagedObjectContext
    
    init(){
        appDel = (UIApplication.sharedApplication().delegate) as! AppDelegate
        context = appDel.managedObjectContext!
    }
    
    func saveCard(data:NSDictionary, c:CreditCardInformation){
        var newCard = NSEntityDescription.insertNewObjectForEntityForName("Cards", inManagedObjectContext: context) as! NSManagedObject
        newCard.setValue(c.ccNickName, forKey: "nickname")
        context.save(nil)
        println(newCard)
        println("Card saved")
        
    }
}