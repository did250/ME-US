import UIKit
import Firebase
import FirebaseDatabase
import Combine

class AddGroupPopViewController: UIViewController,UITextFieldDelegate {

    var ref : DatabaseReference!
    var userinfo = userstruct(Frequest: [""], Grequest: [""], friends: [""], groups: [""], id: "", key: "", name: "", schedules: [[""]], uid: "")
    var disposalblebag = Set<AnyCancellable>()
    
    @IBOutlet var groupname: UITextField!
    @IBOutlet var labelalready: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBinding()
        labelalready.isHidden = true
        ref = Database.database().reference()
        groupname.delegate = self
    }

    @IBAction func btnOK(_ sender: UIButton) {
        guard let input = groupname.text else {return}
        if self.userinfo.groups.contains(input){
            labelalready.isHidden = false
        }
        else {
            viewModel.AddGroup(new: input){flag in}
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func btncancel(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == groupname {
            groupname.resignFirstResponder()
        }
        return true
    }
}

// MARK: - ViewModel Binding
extension AddGroupPopViewController {
    func setBinding(){
        viewModel.$userinfo.sink{ (userinfo : userstruct) in
            self.userinfo = userinfo
        }.store(in: &disposalblebag)
    }
}
