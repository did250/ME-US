import Foundation
import UIKit

class Cells: UITableViewCell{
    @IBOutlet weak var Txt: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    
    
    @IBOutlet weak var deleteBtn: UIButton!
    
    @IBAction func tapDeleteBtn(_ sender: UIButton) {
        viewModel.DeleteSchedule(target: self.Txt.text!)
    }
}
