
import UIKit
import CoreData

class ProfileViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, PaymentViewProtocol {

    @IBOutlet var txtUserName: UITextField!
    @IBOutlet var txtPhone: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var txtPin: UITextField!
    @IBOutlet var lstCreditCards: UITableView!
    
     func postData(data:NSDictionary!) ->Void{
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.lstCreditCards.reloadData()
        })
    }

    
    @IBAction func onAddProfile(sender: UIButton) {
        println("In add profile")
        var appDel:AppDelegate = (UIApplication.sharedApplication().delegate) as! AppDelegate
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var newUser = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: context) as! NSManagedObject
        
        var profile : BaseProperties = ProfileInformation(
            userName: txtUserName.text,
            phone: txtPhone.text, email: txtEmail.text,
            password: txtPassword.text, pin: txtPin.text)
        
        println(profile.getServerURL())
        let uiv:UIViewController = self as UIViewController;
        
        profile.postData(self)
    }
    
    @IBOutlet var tableCards: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let info = ProfileInformation()
        txtUserName.text = info.username
        txtPhone.text = info.phone
        txtEmail.text = info.email
        
        lstCreditCards.delegate = self
        lstCreditCards.dataSource = self
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    @IBAction func cancelToProfileViewController(segue:UIStoryboardSegue) {
    }
    
    @IBAction func saveToProfileViewController(segue:UIStoryboardSegue) {
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let crd:CrditCardViewController = segue.destinationViewController as! CrditCardViewController
        crd.parent = self
        
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
            let cell = UITableViewCell()
            cell.textLabel!.text = user.valueForKey("nickname") as! String!
            return cell
    }
}
