
import UIKit

class PopViewController: UIViewController {

    @IBOutlet var popup: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func btnok(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
}
