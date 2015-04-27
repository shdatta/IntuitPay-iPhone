
import Foundation
import UIKit
import CoreData

class BaseProperties {
    
    var serverUrl = "http://localhost:3000/"

    
    init(){

    }
    
    func getServerURL()->String{
        return ""
    }
    
    func getPostData()->Dictionary<String, String>!{
        return nil
    }
    
    func save(data:NSDictionary!) ->Void{
    }
    
    func validate(id:String) ->String{
        return ""
    }
    
    func postData(uiv:PaymentViewProtocol!){//, callbackPost:(NSDictionary, BaseProperties, UIViewController!) -> Void){
        
        let appDel:AppDelegate = (UIApplication.sharedApplication().delegate) as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext!

        var postData = self.getPostData()
        var url =  self.getServerURL()
        println(postData)
        println(url)
        
        if (NSJSONSerialization.isValidJSONObject(self.getPostData())){
            var session = NSURLSession.sharedSession()
            var err :NSError?
            var response: NSURLResponse?
            let data = NSJSONSerialization.dataWithJSONObject(postData, options:nil, error: &err)
            println(data)
            
            var request : NSMutableURLRequest = NSMutableURLRequest()
            request.URL = NSURL(string:url)
            request.HTTPMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.HTTPBody = NSJSONSerialization.dataWithJSONObject(postData, options:nil, error: &err)
            var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary!
                self.save(json!)
                uiv.postData(json!)
                if let s = self as? ProfileInformation{
                    appDel.phone_info = s
                }
            })
            task.resume()
        }
    }
}
