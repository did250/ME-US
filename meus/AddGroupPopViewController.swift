import UIKit
import Firebase
import FirebaseDatabase

class AddGroupPopViewController: UIViewController {

    var ref : DatabaseReference!
    var myid : String = ""
    var myuid : String = ""
    var groups : [String] = []
    
    @IBOutlet var groupname: UITextField!
    @IBOutlet var labelalready: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelalready.isHidden = true
        ref = Database.database().reference()
    }

    @IBAction func btnOK(_ sender: UIButton) {
        guard let input = groupname.text else {return}
        if groups.contains(input){
            labelalready.isHidden = false
        }
        else {
            groups.append(input)
            self.ref.child("users").child(myuid).updateChildValues(["groups": groups])
            self.dismiss(animated: false, completion: nil)
            
        }
    }
    
    @IBAction func btncancel(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
}
