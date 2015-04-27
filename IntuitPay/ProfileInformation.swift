import Foundation
import UIKit
import CoreData

class ProfileInformation : BaseProperties {
    var username : String!
    var phone : String!
    var email : String!
    var password : String!
    var pin : String!
    
    
    init(userName:String, phone:String, email:String, password : String, pin:String ){
        
        super.init()
        construct(userName, phone: phone, email: email, password: password, pin: pin)
    }
    
    func construct(userName:String!, phone:String!, email:String!, password : String!, pin:String! ) -> Void{
        self.username = userName
        self.phone = phone
        self.email = email
        self.password = password
        self.pin = pin
    }
    
    override init(){
        
        super.init()
        let appDel:AppDelegate = (UIApplication.sharedApplication().delegate) as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext!


        var request = NSFetchRequest(entityName: "User")
        request.returnsObjectsAsFaults = false
        
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        if (results.count > 0){
            var user = results[0] as! NSManagedObject
            self.username = user.valueForKey("username") as! String!
            self.phone = user.valueForKey("phone") as! String!
            self.email = user.valueForKey("email") as! String!
        }
    }
    
    override  func getServerURL() -> String {
        return serverUrl + "createuser"
    }
    
    override func getPostData() -> Dictionary<String, String>! {
        var params = [String: String](minimumCapacity: 5)
        params["username"] = username
        params["phone_number"] = phone
        params["email"] = email
        params["password"] = password
        params["pin"] = pin
        return params
    }
    
    
    override func save(data:NSDictionary!) ->Void{
        
        let appDel:AppDelegate = (UIApplication.sharedApplication().delegate) as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var newUser = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: context) as! NSManagedObject
        newUser.setValue(self.username, forKey: "username")
        newUser.setValue(self.phone, forKey: "phone")
        newUser.setValue(self.email, forKey: "email")
        
        context.save(nil)
        println(newUser)
        println("User saved")
    }
}
