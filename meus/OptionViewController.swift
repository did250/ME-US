import UIKit

class OptionViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var optionTable: UITableView!
    
    lazy var mySection: [SectionData] = {
        let section1 = SectionData(title: "내정보", data: "최현성")
        let section2 = SectionData(title: "계정", data: "비밀번호 변경","로그아웃","회원탈퇴")
        let section3 = SectionData(title: "앱설정", data: "알림설정","일정 초기화","친구목록 초기화","그룹 초기화")
        let section4 = SectionData(title: "이용안내", data: "앱버전","공지사항","개인정보처리")
        return [section1,section2,section3,section4]
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return mySection.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mySection[section].title
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mySection[section].numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celltitle = mySection[indexPath.section][indexPath.row]
        let cell = optionTable.dequeueReusableCell(withIdentifier: "optionCell", for: indexPath) as! OptionTableViewCell
        if indexPath.section == 0 {
            cell.label1.text = celltitle
            cell.label2.text = "test@gmail.com"
            return cell
        } else {
            cell.label1.text = celltitle
            cell.label2.text = ""
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        optionTable.delegate = self
        optionTable.dataSource = self
        optionTable.separatorStyle = .none
    }
    
}
