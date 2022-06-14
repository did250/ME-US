
import UIKit

class AddFriendPopViewController: UIViewController {

    var myid : String = ""
    
    @IBOutlet var friedid: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnOK(_ sender: Any) {
        guard let input = friedid.text else {return}
        
        self.dismiss(animated: false, completion: nil)
    }
    
}
