//
//  Communication.swift
//  IntuitPay
//
//  Created by Nanjappa, Srikanta on 3/15/15.
//  Copyright (c) 2015 Nanjappa, Srikanta. All rights reserved.
//
import UIKit
import Foundation

class Communication {
    var Success : Bool!
    
    init(){
    }
    
    
    func postData(properties:BaseProperties, callbackPost:(NSDictionary, BaseProperties) -> Void){
        
        var myDict: [String: String];
        if let path = NSBundle.mainBundle().pathForResource("IntuitPay", ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path) as! Dictionary<String, String>!
        }
        
        var postData = properties.getPostData()
        var url =  properties.getServerURL()
        println(postData)
        println(url)
        
        if (NSJSONSerialization.isValidJSONObject(properties.getPostData())){
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
                var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
                callbackPost(json!, properties)
//                let msg = json!["message"] as! String
            })
            
            task.resume()
        }
    }
}
