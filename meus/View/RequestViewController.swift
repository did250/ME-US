import UIKit
import Combine

class RequestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var userinfo = userstruct(Frequest: [""], Grequest: [""], friends: [""], groups: [""], id: "", key: "", name: "", schedules: [[""]], uid: "")
    var disposalblebag = Set<AnyCancellable>()
    var requests : [String] = []
    var flag = ""
    
    @IBOutlet var Requesttable: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Requesttable.dequeueReusableCell(withIdentifier: "RequestTableViewCell", for: indexPath) as! RequestTableViewCell
        cell.flag = flag
        cell.name.text = requests[indexPath.row]
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setBinding()
        Requesttable.delegate = self
        Requesttable.dataSource = self
    }
    
    @IBAction func OK(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
}

// MARK: - ViewModel Binding
extension RequestViewController {
    func setBinding(){
        viewModel.$userinfo.sink{ (userinfo : userstruct) in
            self.userinfo = userinfo
            if self.flag == "group"{
                self.requests = userinfo.Grequest
                self.Requesttable.reloadData()
            }
            else if self.flag == "friend"{
                self.requests = userinfo.Frequest
                self.Requesttable.reloadData()
            }
        }.store(in: &disposalblebag)
    }
}
