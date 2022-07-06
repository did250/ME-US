import Firebase
import UIKit
import CodableFirebase
import FirebaseDatabase
import Combine

class UsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ref : DatabaseReference!
    var disposalblebag = Set<AnyCancellable>()
    var userinfo = userstruct(Frequest: [""], Grequest: [""], friends: [""], groups: [""], id: "", key: "", name: "", schedules: [[""]], uid: "")
    var currentgroup: String = ""
    
    @IBOutlet var GroupTable: UITableView!
    @IBOutlet var FriendTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        setBinding()
        viewModel.Loaduser(uid : Auth.auth().currentUser!.uid){data in
            print("Loaduser")
        }
        GroupTable.delegate = self
        GroupTable.dataSource = self
        FriendTable.delegate = self
        FriendTable.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let newvc = self.storyboard?.instantiateViewController(withIdentifier: "MeViewController") as? MeViewController else {return}
        newvc.uid = Auth.auth().currentUser!.uid
        viewModel.Loaduser(uid : Auth.auth().currentUser!.uid){data in
            print("Loaduser")
        }
    }
    
    @IBAction func Refresh(_ sender: UIButton) {
        viewModel.Loaduser(uid : Auth.auth().currentUser!.uid){data in
            print("Loaduser")
        }
    }
    
    @IBAction func addgroup(_ sender: UIButton) {
        guard let popup = self.storyboard?.instantiateViewController(withIdentifier: "AddGroupPopViewController") as? AddGroupPopViewController else {return}
        popup.modalPresentationStyle = .fullScreen
        popup.modalTransitionStyle = .crossDissolve
        self.present(popup, animated: true, completion: nil)
    }
    
    @IBAction func grouprequest(_ sender: UIButton) {
        guard let popup = self.storyboard?.instantiateViewController(withIdentifier: "RequestViewController") as? RequestViewController else {return}
        popup.flag = "group"
        popup.modalPresentationStyle = .overFullScreen
        popup.modalTransitionStyle = .crossDissolve
        self.present(popup, animated: true, completion: nil)
    }
    
    @IBAction func addfriend(_ sender: UIButton) {
        guard let popup = self.storyboard?.instantiateViewController(withIdentifier: "AddFriendPopViewController") as? AddFriendPopViewController else {return}
        popup.modalPresentationStyle = .overFullScreen
        popup.modalTransitionStyle = .crossDissolve
        self.present(popup, animated: true, completion: nil)
    }
    
    @IBAction func friendrequest(_ sender: UIButton) {
        guard let popup = self.storyboard?.instantiateViewController(withIdentifier: "RequestViewController") as? RequestViewController else {return}
        popup.flag = "friend"
        popup.modalPresentationStyle = .fullScreen
        popup.modalTransitionStyle = .crossDissolve
        self.present(popup, animated: true, completion: nil)
    }
}

// MARK: - ViewModel Binding
extension UsViewController {
    func setBinding(){
        viewModel.$userinfo.sink{ (userinfo : userstruct) in
            self.userinfo = userinfo
            self.GroupTable.reloadData()
            self.FriendTable.reloadData()
        }.store(in: &disposalblebag)
    }
}

// MARK: - TableView Methods
extension UsViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == GroupTable {
            return userinfo.groups.count
        }
        if tableView == FriendTable {
            return userinfo.friends.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = GroupTable.dequeueReusableCell(withIdentifier: "Cells", for: indexPath) as! Cells
        if tableView == self.GroupTable {
            cell.Txt.text = userinfo.groups[indexPath.row]
            return cell
        }
        if tableView == self.FriendTable {
            cell.Txt.text = userinfo.friends[indexPath.row]
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == GroupTable {
            return "Group"
        }
        if tableView == FriendTable {
            return "Friend"
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = FriendTable.dequeueReusableCell(withIdentifier: "Cells", for: indexPath) as! Cells
        if tableView == FriendTable {
            viewModel.FindFriend(name: cell.Txt.text!){frienduid in
                guard let newvc = self.storyboard?.instantiateViewController(withIdentifier: "MeViewController") as? MeViewController else {return}
                newvc.uid = frienduid
                self.present(newvc, animated: true, completion: nil)
            }
        }
        else if tableView == GroupTable {
            let cell2 = GroupTable.dequeueReusableCell(withIdentifier: "Cells", for: indexPath) as! Cells
            guard let newvc = self.storyboard?.instantiateViewController(withIdentifier: "GroupViewController") as? GroupViewController else {return}
            
            newvc.myid = userinfo.id
            newvc.name = userinfo.groups[indexPath.row]
            newvc.modalPresentationStyle = .fullScreen
            newvc.modalTransitionStyle = .crossDissolve
            self.present(newvc, animated: true, completion: nil)
        }
    }
}

