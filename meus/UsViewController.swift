import Firebase
import UIKit
import CodableFirebase
import FirebaseDatabase


class UsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ref : DatabaseReference!
    var userinfo : userstruct!
    var groups : [String] = []
    var friends : [String] = []
    var newfriend : String = "kkkkkk"
    
    @IBOutlet var GroupTable: UITableView!
    @IBOutlet var FriendTable: UITableView!
    
    @IBOutlet var addgroup: UIButton!
    @IBOutlet var grouprequest: UIButton!
    @IBOutlet var addfriend: UIButton!
    @IBOutlet var friendrequest: UIButton!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == GroupTable {
            return groups.count
        }
        if tableView == FriendTable {
            return friends.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = GroupTable.dequeueReusableCell(withIdentifier: "Cells", for: indexPath) as! Cells
        if tableView == self.GroupTable {
            cell.Txt.text = groups[indexPath.row]
            return cell
        }
        if tableView == self.FriendTable {
            cell.Txt.text = friends[indexPath.row]
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(newfriend)
        print("11111")
        ref = Database.database().reference()
        Loaduser()
        GroupTable.delegate = self
        GroupTable.dataSource = self
        FriendTable.delegate = self
        FriendTable.dataSource = self
        
    }
    
    
    @IBAction func addgroup(_ sender: UIButton) {
        
    }
    
    @IBAction func grouprequest(_ sender: UIButton) {
    }
    
    @IBAction func addfriend(_ sender: UIButton) {
        sendFrequest(friendid: "alpa@gmail.com", myid: "asdfafsd")
        let storyboard = UIStoryboard.init(name: "Popup", bundle: nil)
        let popup = storyboard.instantiateViewController(withIdentifier: "AddFriendPopViewController")
        popup.modalPresentationStyle = .overFullScreen
        popup.modalTransitionStyle = .crossDissolve
        self.present(popup, animated: true, completion: nil)
       
        
    }
    
    @IBAction func friendrequest(_ sender: UIButton) {
        
    }
    
}

extension UsViewController {
    // 로그인한 유저 정보 load
    func Loaduser(){
        let uid = Auth.auth().currentUser?.uid
        ref.child("users").child(uid ?? "anyvalue").getData {
            (error, snapshot) in
            if let error = error {
                print("Error \(error)")
            }
            else {
                let value = snapshot?.value
                if let data = try? FirebaseDecoder().decode(userstruct.self, from: value){
                    self.userinfo = data
                    self.groups = self.userinfo.groups
                    self.friends = self.userinfo.friends
                    
                    DispatchQueue.main.async {
                        self.GroupTable.reloadData()
                        self.FriendTable.reloadData()
                    }
                }
                else {
                    print("Error")
                }
            }
        }
    }
    // 친구의 Frequest 에 myid 추가
    func sendFrequest(friendid : String, myid : String) {
        var frienduid : String = ""
        ref.child("users").queryOrdered(byChild: "id").queryEqual(toValue: friendid).observeSingleEvent(of: .value, with: {
            snapshot in
            
            for child in snapshot.children {
                
                let snap = child as! DataSnapshot
                frienduid = snap.key
                print(frienduid)
                self.ref.child("users").child(frienduid).child("Frequest").getData {
                    (error,snapshot) in
                    if let error = error {
                        print("Error \(error)")
                    }
                    else{
                        
                        guard let value = snapshot?.value else {return}
                        if let data2 = try? FirebaseDecoder().decode([String].self, from: value){
                            var array: [String] = data2
                            array.append(myid)
                            self.ref.child("users").child(frienduid).updateChildValues(["Frequest": array])
                           
                        }
                        else{
                            print("Error")
                        }
                        
                    }
                    
                }
                
                
            }
        })
        
    }
}

struct userstruct: Codable{
    let Frequest: [String]
    let Grequest: [String]
    let friends: [String]
    let groups: [String]
    let id: String
    let key: String
    let name: String
    let schedules: [String]
    let uid: String
    enum Codingkeys: String {
        case Frequest = "Frequest"
        case Grequest = "Grequest"
        case friends = "friends"
        case groups = "groups"
        case id = "id"
        case key = "key"
        case name = "name"
        case schedules = "scheduels"
        case uid = "uid"
    }
}


