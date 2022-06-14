
import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    
   
    
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
        
//        let alert = UIAlertController(title: "완료", message: "축하합니다 회원가입이 완료되었습니다^^", preferredStyle: .alert)
//        let check = UIAlertAction(title: "완료", style: .default) { self.presentingViewController?.dismiss(animated: true)} in
//        alert.addAction(check)//. check를 alert에 버튼으로 등록
//        self.present(alert, animated: false)
        
        self.presentingViewController?.dismiss(animated: true)
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
        
        alreadyId.isHidden = true
        
        notSamePw.isHidden = true
        
        numberNotSame.isHidden = true
        
        name.delegate = self
        idAndemail.delegate = self
        pwInputField.delegate = self
        pwreInputField.delegate = self
        emailField.delegate = self
        numberField.delegate = self
    }
    
    
}
