
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
    
     func postData(data:NSDictionary!) ->Void{
        println(data)
        Utils.DisplayMessage("Id:" + (data.valueForKey("id") as! String) +
            "\nStatus:" + (data.valueForKey("status") as! String) +
            "\nAmount:" + (data.valueForKey("amount") as! String))
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


        let payInfo : BaseProperties = PayInformation(
            intuitId: txtIntuitId.text, accountNumber: txtAccountNumber.text!,
            comments: txtNotes.text!, amount: txtAmount.text, cardId: id)
        
        let errMsg:String = payInfo.validate(id)
        if !errMsg.isEmpty{
            Utils.DisplayMessage(errMsg)
            return
        }
        
        let uiv:UIViewController = self as UIViewController;
        payInfo.postData(self)

    }
}

