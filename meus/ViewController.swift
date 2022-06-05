//
//  ViewController.swift
//  meus
//
//  Created by 최현성 on 2022/05/24.
//

import UIKit

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

