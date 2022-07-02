import Firebase
import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    
    var ref: DatabaseReference!
    var focused : Bool = false
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var idAndemail: UITextField!
    @IBOutlet weak var isSameCheck: UIButton!
    
    @IBOutlet weak var number: UIButton!
    
    @IBOutlet weak var numberCheck: UIButton!
    
    @IBOutlet weak var signUpFinishBtn: UIButton!
    
    
    @IBOutlet weak var alreadyId: UILabel!
    
    @IBOutlet weak var pwInputField: UITextField!
    
    @IBOutlet weak var pwreInputField: UITextField!
    
    @IBOutlet weak var notSamePw: UILabel!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var numberField: UITextField!
    
    @IBOutlet weak var numberNotSame: UILabel!
    
    @IBAction func idSameCheck(_ sender: Any) {
        alreadyId.isHidden = false
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func emailnumber(_ sender: Any) {
        
    }
    
    @IBAction func numberCheck(_ sender: Any) {
        numberNotSame.isHidden = false
    }
    
    @IBAction func signUpFinishBtn(_ sender: Any) {
        guard let userEmail = idAndemail.text, let userPassword = pwInputField.text, let userPasswordConfirm = pwreInputField.text, let userName = name.text else {return}
        
        if userEmail == "" || userPassword == "" || userPasswordConfirm == "" || userPassword != userPasswordConfirm {
            // fail
        }
        else {
            Auth.auth().createUser(withEmail: userEmail, password: userPassword ) { [self] authResult, error in
                guard let user = authResult?.user, error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                adduser(uid: user.uid, name: userName)
                self.dismiss(animated: true, completion: nil)
                }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true) // 키보드 있을때 스크롤 드래그시 키보드 사라짐
    }
    
    // 리턴키 눌렀을때 다음 텍스트 필드 이동 및 마지막 텍스트 필드일때 키보드 사라짐
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == name {
            idAndemail.becomeFirstResponder()
        }
        if textField == idAndemail {
            idAndemail.resignFirstResponder()
        }
        if textField == pwInputField {
            pwreInputField.becomeFirstResponder()
        }
        if textField == pwreInputField {
            pwreInputField.resignFirstResponder()
        }
        if textField == emailField {
            numberField.becomeFirstResponder()
        } else {
            numberField.resignFirstResponder()
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        alreadyId.isHidden = true
        notSamePw.isHidden = true
        numberNotSame.isHidden = true
        
        name.delegate = self
        idAndemail.delegate = self
        pwInputField.delegate = self
        pwreInputField.delegate = self
        emailField.delegate = self
        numberField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboarWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            view.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == numberField{
            focused = true
        }
        else if textField == emailField {
            focused = true
        }
        else {
            focused = false
        }
    }
    
    @objc func keyboarWillShow(_ sender:Notification) {
        if focused == true {
            self.view.frame.origin.y = -200
        } else {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func keyboardWillHide(_ sender:Notification) {
        if focused == true {
            self.view.frame.origin.y = 0
        }
    }
    
    func adduser(uid:String, name: String){
        ref.child("users").child(uid).setValue([ "key": ref.childByAutoId().key, "id": idAndemail.text , "uid": uid,"name": name, "friends": ["friends"], "groups": ["groups"], "Frequest": ["Frequest"], "Grequest": ["Grequest"], "schedules": [["크리스마스","2022년 12월 25일","2022년 12월 25일","오전 11시 11분", "오전 11시 12분"]] ])
    }
}
