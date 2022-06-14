
import UIKit
import Firebase

class ViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var idTextField: UITextField!
    
    @IBOutlet weak var pwTextField: UITextField!
    
    @IBAction func idFindBtn(_ sender: Any) {
        let idf = self.storyboard?.instantiateViewController(withIdentifier: "idFindViewController")
        idf?.modalPresentationStyle = .fullScreen // 전체화면으로 보이게
        idf?.modalTransitionStyle = .crossDissolve // 화면 넘어가는 애니메이션
        self.present(idf!, animated: true, completion: nil)
    }
    
    @IBAction func pwFindBtn(_ sender: Any) {
        let pwf = self.storyboard?.instantiateViewController(withIdentifier: "pwFindViewController")
        pwf?.modalPresentationStyle = .fullScreen
        pwf?.modalTransitionStyle = .crossDissolve
        self.present(pwf!, animated: true, completion: nil)
        
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        guard let userEmail = idTextField.text else {return}
        guard let userPassword = pwTextField.text else {return}
        
        Auth.auth().signIn(withEmail: userEmail, password: userPassword) { [weak self] authResult, error in guard self != nil else { return }
            if authResult != nil {
                let tab = self?.storyboard?.instantiateViewController(withIdentifier: "TabBar")
                tab?.modalPresentationStyle = .fullScreen
                tab?.modalTransitionStyle = .crossDissolve
                
                self?.present(tab!, animated: true, completion: nil)
            }
            else {
                print("로그인실패.", error?.localizedDescription ?? "")
                let storyboard = UIStoryboard.init(name: "Popup", bundle: nil)
                let popup = storyboard.instantiateViewController(withIdentifier: "PopViewController")
                popup.modalPresentationStyle = .overFullScreen
                popup.modalTransitionStyle = .crossDissolve
                self?.present(popup, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func signUpBtn(_ sender: Any) {
        //Storyboard를 통해 회원가입의 다음 뷰를 가져오는 코드
        let sbt = self.storyboard?.instantiateViewController(withIdentifier: "signUPViewController")
        sbt?.modalPresentationStyle = .fullScreen // 전체화면으로 보이게
        sbt?.modalTransitionStyle = .flipHorizontal // 화면 넘어가는 애니메이션
        self.present(sbt!, animated: true, completion: nil)
    }
        
        // 화면터치시 키보드 내려가는 코드
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // 리턴키 눌렀을때 다음 텍스트 필드 이동 및 마지막 텍스트 필드일때 키보드 사라짐
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == idTextField {
            pwTextField.becomeFirstResponder()
        } else {
            pwTextField.resignFirstResponder()
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        idTextField.delegate = self
        pwTextField.delegate = self
        
    }

}

