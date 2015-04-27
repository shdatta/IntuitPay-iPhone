import UIKit
import Foundation

class CrditCardViewController: UIViewController {

    @IBOutlet var textCCNickName: UITextField!
    @IBOutlet var textCardNumber: UITextField!
    @IBOutlet var textExpirationDate: UITextField!
    @IBOutlet var textCVV: UITextField!
    @IBOutlet var textName: UITextField!
    
    var parent:UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject?) -> Bool{
        var button : UIBarButtonItem = sender as! UIBarButtonItem
        if button.title == "Save"{
            var ccInfo : BaseProperties = CreditCardInformation(ccNickName: textCCNickName.text,
                ccNumber: textCardNumber.text,
                ccCvv: textCVV.text,
                ccExpirationDate: textExpirationDate.text, 
                ccName:textName.text,
                ccId:"-1");
            
            
            ccInfo.postData(parent)
        }
        return true
    }

}
