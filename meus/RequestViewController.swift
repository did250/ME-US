import UIKit

class RequestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var requests : [String] = ["1", "2"]
    
    @IBOutlet var Requesttable: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Requesttable.dequeueReusableCell(withIdentifier: "RequestTableViewCell", for: indexPath) as! RequestTableViewCell
        cell.name.text = requests[indexPath.row]
        return cell
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        Requesttable.delegate = self
        Requesttable.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func OK(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
}
