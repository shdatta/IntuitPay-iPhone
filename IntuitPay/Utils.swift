//
//  Utils.swift
//  IntuitPay
//
//  Created by Nanjappa, Srikanta on 4/27/15.
//  Copyright (c) 2015 Nanjappa, Srikanta. All rights reserved.
//

import Foundation
import UIKit

class Utils{
    
    class func DisplayMessage(msg:String){
        dispatch_async(dispatch_get_main_queue(),
            {
                () -> Void in
                let alert = UIAlertView(title: "iPay", message: msg, delegate: self, cancelButtonTitle: "Dismiss")
                alert.show()
            }
        );
    }
}
