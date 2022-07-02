import UIKit
import Combine

class RequestTableViewCell: UITableViewCell {
    
    @IBOutlet var name: UILabel!
    var flag = ""
    
    @IBAction func btnAccept(_ sender: UIButton) {
        if flag == "friend"{
            viewModel.AcceptFriend(target: self.name.text!){ t in}
        }
        else if flag == "group"{
            viewModel.AcceptGroup(target: self.name.text!){ t in}
        }
    }
    
    @IBAction func btnDeny(_ sender: UIButton) {
        if flag == "friend"{
            viewModel.DenyFriend(target: self.name.text!)
        }
        else if flag == "group"{
            viewModel.DenyGroup(target: self.name.text!)
        }
        
    }
}

