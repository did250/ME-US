import UIKit
import Firebase
import Combine

class ViewController: UIViewController,UITextFieldDelegate {
    
    var userinfo = userstruct(Frequest: [""], Grequest: [""], friends: [""], groups: [""], id: "", key: "", name: "", schedules: [[""]], uid: "")
    var disposalblebag = Set<AnyCancellable>()
    var viewModel: ViewModel = ViewModel()
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signBtn: UIButton!
    
    
    @IBAction func loginBtn(_ sender: Any) {
        guard let userEmail = idTextField.text else {return}
        guard let userPassword = pwTextField.text else {return}
        viewModel.login(userEmail: userEmail, userPassword: userPassword) { flag in
            if flag == 1{
                let tab = self.storyboard?.instantiateViewController(withIdentifier: "TabBar")
                tab?.modalPresentationStyle = .fullScreen
                tab?.modalTransitionStyle = .crossDissolve
                self.present(tab!, animated: true, completion: nil)
            }
            else if flag == 2{
                let storyboard = UIStoryboard.init(name: "Popup", bundle: nil)
                let popup = storyboard.instantiateViewController(withIdentifier: "PopViewController")
                popup.modalPresentationStyle = .overFullScreen
                popup.modalTransitionStyle = .crossDissolve
                self.present(popup, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func signUpBtn(_ sender: Any) {
        //Storyboard를 통해 회원가입의 다음 뷰를 가져오는 코드
        let sbt = self.storyboard?.instantiateViewController(withIdentifier: "signUPViewController")
        sbt?.modalPresentationStyle = .fullScreen
        sbt?.modalTransitionStyle = .flipHorizontal
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
        
        self.setBinding()
        idTextField.delegate = self
        pwTextField.delegate = self
        
        pwTextField.layer.cornerRadius = 15
        pwTextField.layer.borderWidth = 0
        pwTextField.layer.borderColor = .none
        
        idTextField.layer.cornerRadius = 15
        idTextField.layer.borderWidth = 0
        idTextField.layer.borderColor = .none
        
        loginBtn.layer.cornerRadius = 20
        loginBtn.layer.borderWidth = 0
        loginBtn.layer.borderColor = .none
        
        signBtn.layer.cornerRadius = 20
        signBtn.layer.borderWidth = 0
        signBtn.layer.borderColor = .none
    }
}

extension ViewController {
    func setBinding(){
        self.viewModel.$userinfo.sink{ (userinfo : userstruct) in
        }.store(in: &disposalblebag)
    }
}
