import Firebase
import FirebaseDatabase
import UIKit
import CodableFirebase
class AddFriendPopViewController: UIViewController {

    var ref : DatabaseReference!
    var myid : String = ""
    
    @IBOutlet var friedid: UITextField!
    @IBOutlet var labelsame: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        labelsame.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnOK(_ sender: Any) {
        guard let input = friedid.text else {return}
        if input == myid {
            labelsame.isHidden = false
        }
//        else if (){
//            이미 친추 했는지 검사해야함
//        }
        else {
            sendFrequest(friendid: input, myid: myid)
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func btncancel(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func sendFrequest(friendid : String, myid : String) {
        var frienduid : String = ""
        ref?.child("users").queryOrdered(byChild: "id").queryEqual(toValue: friendid).observeSingleEvent(of: .value, with: {
            snapshot in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                frienduid = snap.key
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
