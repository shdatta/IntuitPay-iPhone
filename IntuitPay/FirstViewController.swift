
import UIKit
import Foundation
import CoreData

class MyCell : UITableViewCell {
    
    var id:String = "";
 
}


class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, PaymentViewProtocol {
    @IBOutlet var lstCards: UITableView!
    @IBOutlet var txtIntuitId: UITextField!
    @IBOutlet var txtAccountNumber: UITextField!
    @IBOutlet var txtNotes: UITextField!
    @IBOutlet var txtAmount: UITextField!
    var id:String = "";
    
    func postData(data:NSDictionary?, error:String?) ->Void{
        println(data)
        if (error != nil){
            Utils.DisplayMessage(error!)
            return
        }
        var msg:String =  "Id:" + (data!.valueForKey("id") as! String) +
            "\nStatus:" + (data!.valueForKey("status") as! String) +
            "\nAmount:" + (data!.valueForKey("amount") as! String) +
            "\nMerchant:" + (data!.valueForKey("merchant") as! String)
        Utils.DisplayMessage(msg)
    }

    override func viewDidAppear(animated: Bool) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.lstCards.reloadData()
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        lstCards.delegate = self
        lstCards.dataSource = self
        lstCards.headerViewForSection(1)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let appDel:AppDelegate = (UIApplication.sharedApplication().delegate) as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        var request = NSFetchRequest(entityName: "Cards")
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        return results.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        println("in pop cell")
        
        let appDel:AppDelegate = (UIApplication.sharedApplication().delegate) as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        
        
        var request = NSFetchRequest(entityName: "Cards")
        request.returnsObjectsAsFaults = false
        
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        var user = results[indexPath.row] as! NSManagedObject
        let cell = MyCell()
        cell.textLabel!.text = user.valueForKey("nickname") as! String!
        cell.id = user.valueForKey("id") as! String!
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return "Select card to pay"
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
            let newCell = tableView.cellForRowAtIndexPath(indexPath) as! MyCell
            self.id = newCell.id
            newCell.accessoryType = .Checkmark
    }

    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath){
        let lastCell = tableView.cellForRowAtIndexPath(indexPath)
        lastCell?.accessoryType = .None
    }

    @IBAction func OnPay(sender: UIButton) {
        let payInfo : PayInformation = PayInformation(
            intuitId: self.txtIntuitId.text, accountNumber: self.txtAccountNumber.text!,
            comments: self.txtNotes.text!, amount: self.txtAmount.text, cardId: self.id)
        
        let errMsg:String = payInfo.validate(self.id)
        if !errMsg.isEmpty{
            Utils.DisplayMessage(errMsg)
            return
        }
        
        showAlertTapped(payInfo)
    }
    
    func showAlertTapped(payInfo: PayInformation?) ->Bool{
        //Create the AlertController
        let actionSheetController: UIAlertController = UIAlertController(title: "Alert", message: "Enter the pin", preferredStyle: .Alert)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Do some stuff
        }
        actionSheetController.addAction(cancelAction)
        //Create and an option action
        let nextAction: UIAlertAction = UIAlertAction(title: "OK", style: .Default) { action -> Void in
            let uiv:UIViewController = self as UIViewController;
            println("You entered \((actionSheetController.textFields?.first as! UITextField).text)")
            payInfo?.pin = (actionSheetController.textFields?.first as! UITextField).text
            payInfo!.postData(self)
        }
        actionSheetController.addAction(nextAction)
        //Add a text field
        actionSheetController.addTextFieldWithConfigurationHandler {(textField: UITextField!) in
            textField.placeholder = "pin"
            textField.secureTextEntry = true
            textField.textColor = UIColor.blueColor()
        }
            
        //Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
        return false
    }
}

