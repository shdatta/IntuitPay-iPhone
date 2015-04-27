
import UIKit
import Foundation
import CoreData

class MyCell : UITableViewCell {
    
    var id:String = "";
 
}


class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var lstCards: UITableView!
    @IBOutlet var txtIntuitId: UITextField!
    @IBOutlet var txtAccountNumber: UITextField!
    @IBOutlet var txtNotes: UITextField!
    @IBOutlet var txtAmount: UITextField!
    
    var id:String = "";

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

    @IBAction func OnPat(sender: UIButton) {
    }
}

