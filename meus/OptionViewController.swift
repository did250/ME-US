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
            cell.selectionStyle = .none
            cell.label2.textAlignment = .left
            cell.label1.text = celltitle
            cell.label2.text = "test@gmail.com"
            return cell
        }
        if indexPath.section == 3 {
            if indexPath.row == 0 {
                cell.selectionStyle = .none
                cell.label1.text = celltitle
                cell.label2.text = "1.00.00"
                return cell
            } else {
                cell.label1.text = celltitle
                cell.label2.text = ""
                return cell
            }
        }
        else {
            cell.label1.text = celltitle
            cell.label2.text = ""
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard let pwChange = storyboard?.instantiateViewController(withIdentifier: "PasswordChangeViewController") else { return }
        let storyboard = UIStoryboard.init(name: "Main" , bundle: Bundle.main)
        guard let secondPop = storyboard.instantiateViewController(withIdentifier: "SecondPopViewController") as? SecondPopViewController else { return }
        
        guard let alarmSetting = storyboard.instantiateViewController(withIdentifier: "AlarmSettingViewController") as? AlarmSettingViewController else { return }
        guard let info = storyboard.instantiateViewController(withIdentifier: "InfoViewController") as? InfoViewController else { return }
        guard let privacy = storyboard.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as? PrivacyPolicyViewController else { return }
        
        
        if indexPath.section == 1{
            switch indexPath.row {
            case 0:
                pwChange.modalPresentationStyle = .fullScreen
                pwChange.modalTransitionStyle = .crossDissolve
                self.present(pwChange, animated: true, completion: nil)
            case 1:
                secondPop.data = "로그아웃 하시겠습니까?"
                secondPop.name1 = "로그아웃"
                secondPop.flag = "logout"
                secondPop.modalPresentationStyle = .overFullScreen
                secondPop.modalTransitionStyle = .coverVertical
                self.present(secondPop, animated: true, completion: nil)
            default:
                break
            }
        }
        if indexPath.section == 2 {
            switch indexPath.row {
            case 0: alarmSetting.modalPresentationStyle = .fullScreen
                    alarmSetting.modalTransitionStyle = .crossDissolve
                    self.present(alarmSetting, animated: true, completion: nil)
            case 1: secondPop.data = "일정을 초기화 하시겠습니까?"
                    secondPop.name1 = "초기화"
                    secondPop.modalPresentationStyle = .overFullScreen
                    secondPop.modalTransitionStyle = .coverVertical
                    secondPop.flag = "dailylist"
                    self.present(secondPop, animated: true, completion: nil)
            case 2: secondPop.data = "친구목록을 초기화 하시겠습니까?"
                    secondPop.name1 = "초기화"
                secondPop.flag = "friendlist"
                    secondPop.modalPresentationStyle = .overFullScreen
                    secondPop.modalTransitionStyle = .coverVertical
                    self.present(secondPop, animated: true, completion: nil)
            case 3: secondPop.data = "그룹을 초기화 하시겠습니까?"
                    secondPop.name1 = "초기화"
                    secondPop.flag = "grouplist"
                    secondPop.modalPresentationStyle = .overFullScreen
                    secondPop.modalTransitionStyle = .coverVertical
                    self.present(secondPop, animated: true, completion: nil)
            default:
                break
            }
        }
        if indexPath.section == 3 {
            switch indexPath.row {
            case 1: info.modalPresentationStyle = .popover
                    info.modalTransitionStyle = .coverVertical
                    self.present(info, animated: true, completion: nil)
            case 2: privacy.modalPresentationStyle = .popover
                    privacy.modalTransitionStyle = .coverVertical
                    self.present(privacy, animated: true, completion: nil)
            default:
                break
            }
        }
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        optionTable.delegate = self
        optionTable.dataSource = self
        optionTable.separatorStyle = .none
    }
    
}
