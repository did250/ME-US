import Firebase
import FirebaseDatabase
import CodableFirebase
import UIKit
import Combine

class GroupViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var members : [String] = []
    var myid : String = ""
    var name = ""
    var ref : DatabaseReference!
    
    var userinfo = userstruct(Frequest: [""], Grequest: [""], friends: [""], groups: [""], id: "", key: "", name: "", schedules: [[""]], uid: "")
    
    var groupinfo = groupstruct(members: [""])
    
    var disposalblebag = Set<AnyCancellable>()
    
    @IBOutlet weak var groupname: UILabel!
    @IBOutlet weak var membertable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setBinding()
        viewModel.LoadGroup(group: name){data in
            self.members = viewModel.AddGroupMembers()
            self.membertable.reloadData()
            viewModel.MixedSchedule(members: self.members){ i in
                print("asdfasdfasdfasdfasdfasd;fklasdjf;lkasdjl;kdsjlk;j")
            }
        }
        
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
        msvc.groupname = self.name
        msvc.members = self.members
        msvc.modalPresentationStyle = .fullScreen
        msvc.modalTransitionStyle = .crossDissolve
        self.present(msvc, animated: true, completion: nil)
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}

extension GroupViewController {
    func setBinding(){
        viewModel.$groupinfo.sink{ (groupinfo : groupstruct) in
            self.groupinfo = groupinfo
            self.membertable.reloadData()
        }.store(in: &disposalblebag)
    }
}


// 테이블뷰
extension GroupViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = membertable.dequeueReusableCell(withIdentifier: "Cells", for: indexPath) as! Cells
        cell.Txt.text = members[indexPath.row]
        return cell
    }
}
