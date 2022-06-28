import UIKit

class SecondPopViewController: UIViewController {
    
    var flag = ""
    
    @IBOutlet weak var secondPopView: UIView!
    
    @IBOutlet weak var popLabel: UILabel!
    
    var data: String?
    
    @IBOutlet weak var btn1name: UIButton!
    
    var name1: String?
    
    @IBOutlet weak var btn2name: UIButton!
    
    @IBAction func btn1(_ sender: Any) {
        if flag == "logout" {
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController else { return }
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true , completion: nil)
        }
        else if flag == "GroupOut" {
            
        }
    }
    
    @IBAction func btn2(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = data {
            popLabel.text = data
            popLabel.sizeToFit()
        }
        if flag == "GroupOut" {
            popLabel.text = "그룹에서 탈퇴 하시겠습니까?"
        }
        
        
        
        
        let button = btn1name.setTitle(name1, for: .normal)
        
    }
    

    

}
