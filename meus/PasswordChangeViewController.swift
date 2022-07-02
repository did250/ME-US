
import UIKit

class PasswordChangeViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var currentPw: UITextField!
    
    @IBOutlet weak var newPw: UITextField!
    
    @IBOutlet weak var checkPw: UITextField!
    
    @IBOutlet weak var pwDefer: UILabel!
    
    @IBOutlet weak var pwNotSame: UILabel!
    
    
    @IBAction func BackBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeBtn(_ sender: Any) {
        
        let alert = UIAlertController(title: "알림", message: "비밀번호 변경 하시겠습니까?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "비밀번호 변경", style: .default) { UIAlertAction in
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController else { return }
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true , completion: nil)
        }
        let no = UIAlertAction(title: "취소", style: .default) { UIAlertAction in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(ok)
        alert.addAction(no)
        
        self.present(alert, animated: true, completion: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == currentPw {
            newPw.becomeFirstResponder()
        }
        if textField == newPw {
            checkPw.becomeFirstResponder()
        } else {
            checkPw.resignFirstResponder()
        }
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentPw.delegate = self
        newPw.delegate = self
        checkPw.delegate = self
    }
    
}
