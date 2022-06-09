//
//  ViewController.swift
//  meus
//
//  Created by 최현성 on 2022/05/24.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
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
//        let firstVC = storyboard!.instantiateViewController(withIdentifier: "MeVIewController")
//        let tbc = UITabBarController()
//        tbc.viewControllers = [firstVC]
//        
//        present(tbc, animated: true)
    }
    
    @IBAction func signUpBtn(_ sender: Any) {
        //Storyboard를 통해 회원가입의 다음 뷰를 가져오는 코드
        let sbt = self.storyboard?.instantiateViewController(withIdentifier: "signUPViewController")
        sbt?.modalPresentationStyle = .fullScreen // 전체화면으로 보이게
        sbt?.modalTransitionStyle = .flipHorizontal // 화면 넘어가는 애니메이션
        self.present(sbt!, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
    }


}

