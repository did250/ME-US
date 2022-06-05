//
//  signUPViewController.swift
//  meus
//
//  Created by 최현성 on 2022/05/28.
//

import UIKit

class SignUpViewController: UIViewController {
    
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alreadyId.isHidden = true
        
        notSamePw.isHidden = true
        
        numberNotSame.isHidden = true
        
    }
    

    

}
