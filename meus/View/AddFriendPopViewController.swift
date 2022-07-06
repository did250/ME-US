import Firebase
import FirebaseDatabase
import UIKit
import CodableFirebase
import Combine

class AddFriendPopViewController: UIViewController, UITextFieldDelegate {

    var ref : DatabaseReference!
    var flag : String = ""
    var myid : String = ""
    var currentgroup = ""
    var userinfo = userstruct(Frequest: [""], Grequest: [""], friends: [""], groups: [""], id: "", key: "", name: "", schedules: [[""]], uid: "")
    var disposalblebag = Set<AnyCancellable>()
    
    @IBOutlet var friedid: UITextField!
    @IBOutlet var labelsame: UILabel!
    @IBOutlet var labelalready: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        labelsame.isHidden = true
        labelalready.isHidden = true
        friedid.delegate = self
    }
    
    @IBAction func btnOK(_ sender: Any) {
        guard let input = friedid.text else {return}
        if input == self.userinfo.id {
            labelsame.isHidden = false
            labelalready.isHidden = true
        }
        else {
            viewModel.sendFrequest(friendid: input, flag: flag, groupname: currentgroup){t in
                if t == 3 || t == 1 {
                    self.dismiss(animated: false, completion: nil)
                }
                else{
                    self.labelalready.isHidden = false
                    self.labelsame.isHidden = true
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == friedid {
            friedid.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func btncancel(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
}

// MARK: - ViewModel Binding
extension AddFriendPopViewController {
    func setBinding(){
        viewModel.$userinfo.sink{ (userinfo : userstruct) in
            self.userinfo = userinfo
        }.store(in: &disposalblebag)
    }
}
