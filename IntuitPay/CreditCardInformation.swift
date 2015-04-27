
import Foundation
import UIKit
import CoreData

class CreditCardInformation : BaseProperties {
    var ccCvv : String!
    var ccNumber : String!
    var ccExpirationDate : String!
    var ccNickName : String!
    var ccName : String!
    var commUrl : String!
    var ccId:String!
    
    init(ccNickName:String, ccNumber:String, ccCvv : String, ccExpirationDate:String, ccName:String, ccId:String ){
        
        super.init()
        self.ccCvv = ccCvv
        self.ccExpirationDate = ccExpirationDate
        self.ccNumber = ccNumber
        self.ccNickName = ccNickName
        self.ccName = ccName
        self.ccId = ccId
        self.commUrl = serverUrl + "addCard"
    }
    
    override  func getServerURL() -> String {
        return serverUrl + "createcard"
    }
    
    override func getPostData() -> Dictionary<String, String>! {
        
        let appDel:AppDelegate = (UIApplication.sharedApplication().delegate) as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var params = [String: String](minimumCapacity: 7)

        params["cvc"] = ccCvv
        params["card_number"] = ccNumber
        params["nick_name"] = ccNickName
        params["name"] = ccName
        params["expiry"] = ccExpirationDate
        params["id"] = ccId
        params["phone_number"] = appDel.phone_info?.phone
        return params
    }
    
    override func save(data:NSDictionary!) ->Void{
        
        let appDel:AppDelegate = (UIApplication.sharedApplication().delegate) as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var newCard = NSEntityDescription.insertNewObjectForEntityForName("Cards", inManagedObjectContext: context) as! NSManagedObject
        let id  = data!["id"] as! String
        newCard.setValue(self.ccNickName, forKey: "nickname")
        newCard.setValue(data!["id"] as! String, forKey: "id")
        context.save(nil)
        println(newCard)
        println("Card saved")
    }

}
