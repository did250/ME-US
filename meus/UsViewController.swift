//
//  UsViewController.swift
//  meus
//
//  Created by 양희원 on 2022/06/09.
//

import UIKit

class UsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var groups = ["가족", "친구", "팀플", "Group", "축구", "어벤져스", "멘사", "롤", "친척"]
    var friends = ["양희원", "박중선", "최현성", "A", "B", "C"]
    @IBOutlet var GroupTable: UITableView!
    @IBOutlet var FriendTable: UITableView!
    
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
        GroupTable.delegate = self
        GroupTable.dataSource = self
        FriendTable.delegate = self
        FriendTable.dataSource = self
        // Do any additional setup after loading the view.
    }
    
}


