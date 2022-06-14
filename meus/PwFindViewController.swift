
import UIKit

class PwFindViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var idField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var certificationField: UITextField!
    
    @IBOutlet weak var certiNumNotSameField: UILabel!
    
    @IBAction func certificationBtn(_ sender: Any) {
        
    }
    
    @IBAction func okBtn(_ sender: Any) {
        certiNumNotSameField.isHidden = false
    }
    
    @IBAction func passwordFindBtn(_ sender: Any) {
        
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        let lbt = self.storyboard?.instantiateViewController(withIdentifier: "ViewController")
        lbt?.modalPresentationStyle = .fullScreen // 전체화면으로 보이게
        lbt?.modalTransitionStyle = .flipHorizontal // 화면 넘어가는 애니메이션
        self.present(lbt!, animated: true, completion: nil)
    }
    
    

    @IBAction func backBtn(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // 리턴키 눌렀을때 다음 텍스트 필드 이동 및 마지막 텍스트 필드일때 키보드 사라짐
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameField {
            idField.becomeFirstResponder()
        }
        if textField == idField {
            emailField.becomeFirstResponder()
        }
        if textField == emailField {
            certificationField.becomeFirstResponder()
        } else {
            certificationField.resignFirstResponder()
        }
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        certiNumNotSameField.isHidden = true
        
        
        nameField.delegate = self
        idField.delegate = self
        emailField.delegate = self
        certificationField.delegate = self
        
    }
    

    

}
