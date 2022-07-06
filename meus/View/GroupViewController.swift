import UIKit

class GroupViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var members : [String] = ["양희원","빅중선","한성호","임후남"]
    var myid : String = ""
    var name = ""
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = membertable.dequeueReusableCell(withIdentifier: "Cells", for: indexPath) as! Cells
        cell.Txt.text = members[indexPath.row]
        return cell
    }
    

    @IBOutlet weak var groupname: UILabel!
    
    
    @IBOutlet weak var membertable: UITableView!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        membertable.delegate = self
        membertable.dataSource = self
       
        self.groupname.text = name
    }
    
    @IBAction func groupinvite(_ sender: UIButton) {
        guard let popup = self.storyboard?.instantiateViewController(withIdentifier: "AddFriendPopViewController") as? AddFriendPopViewController else { return }
        popup.myid = myid
        popup.flag = "GroupInvite"
        popup.currentgroup = name
        popup.modalPresentationStyle = .overFullScreen
        popup.modalTransitionStyle = .crossDissolve
        self.present(popup, animated: true , completion: nil)
    }
    
    @IBAction func groupout(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "Popup" , bundle: nil)
        guard let popup = storyboard.instantiateViewController(withIdentifier: "SecondPopViewController") as? SecondPopViewController else { return }
        popup.flag = "GroupOut"
        popup.modalPresentationStyle = .overFullScreen
        popup.modalTransitionStyle = .crossDissolve
        present(popup, animated: true, completion: nil)
        
    }
    @IBAction func schedulemix(_ sender: UIButton) {
        guard let msvc = self.storyboard?.instantiateViewController(withIdentifier: "MixedScheduleViewController") as? MixedScheduleViewController else {return}
        msvc.modalPresentationStyle = .fullScreen
        msvc.modalTransitionStyle = .crossDissolve
        self.present(msvc, animated: true, completion: nil)
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}
