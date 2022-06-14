import UIKit

class IdFindViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBAction func idFindBtn(_ sender: Any) {
        
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
            emailField.becomeFirstResponder()
        } else {
            emailField.resignFirstResponder()
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.delegate = self
        emailField.delegate = self
        
    }
}
