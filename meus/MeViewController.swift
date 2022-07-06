import Firebase
import FirebaseDatabase
import CodableFirebase
import UIKit
import Combine

var selectedDate = Date()
var viewModel: ViewModel = ViewModel()



class MeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    var uid = Auth.auth().currentUser?.uid
    var ref : DatabaseReference!
    
    var userinfo = userstruct(Frequest: [""], Grequest: [""], friends: [""], groups: [""], id: "", key: "", name: "", schedules: [[""]], uid: "")
    
    var disposalblebag = Set<AnyCancellable>()
    
    
    @IBOutlet var backbutton: UIButton!
    @IBOutlet var Calendarname: UILabel!
    @IBOutlet var addbutton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet var ScheduleTable: UITableView!

    var totalSquares = [String]()
    var currentSchedule:[Schedule] = []     // 그 달의 모든 스케줄
    var daySchedule:[Schedule] = []         // 그 날의 스케쥴
    var currentDays:[Int] = []              // 그 달의 스케줄이 있는 날짜들
    var selectedIndex = -1
    var m: Int = 0
    var y: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()

        self.setBinding()
        viewModel.Loaduser(uid : Auth.auth().currentUser!.uid){data in
            scheduleList.removeAll()
            viewModel.AddScheduleList()
        }
        
        self.navigationItem.hidesBackButton = true
        setCellsView()
        setMonthView()
        collectionView.delegate = self
        collectionView.dataSource = self
        ScheduleTable.dataSource = self
        ScheduleTable.delegate = self
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (uid != Auth.auth().currentUser?.uid){
            self.Calendarname.text = userinfo.name + "'s Calendar"
            addbutton.isHidden = true
            backbutton.isHidden = false
            addbutton.isEnabled = false
            backbutton.isEnabled = true
        }
        else {
            self.Calendarname.text = "My Calendar"
            addbutton.isHidden = false
            addbutton.isEnabled = true
            backbutton.isHidden = true
            backbutton.isEnabled = false
            viewModel.Loaduser(uid : Auth.auth().currentUser!.uid){data in
                scheduleList.removeAll()
                self.currentDays.removeAll()
                self.currentSchedule.removeAll()
                viewModel.AddScheduleList()
                self.currentSchedule = viewModel.FindcurrentSchedule()
                self.currentDays = viewModel.FindcurrentDays(currentSchedule: self.currentSchedule)
            }
            self.currentDays.removeAll()
            self.currentSchedule.removeAll()
            self.currentSchedule = viewModel.FindcurrentSchedule()
            self.currentDays = viewModel.FindcurrentDays(currentSchedule: self.currentSchedule)
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func backbutton(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func addschedule(_ sender: UIButton) {
        guard let newvc = self.storyboard?.instantiateViewController(withIdentifier: "AddScheduleViewController") as? AddScheduleViewController else {return}
        
        newvc.myuid = userinfo.uid
        newvc.schedules = userinfo.schedules
        newvc.modalPresentationStyle = .fullScreen
        newvc.modalTransitionStyle = .crossDissolve
        self.present(newvc, animated: true, completion: nil)
        
        
    }
    
    @IBAction func previousMonth(_ sender: UIButton) {
        selectedDate = CalendarHelper().minusMonth(date: selectedDate)
        
        currentDays.removeAll()
        currentSchedule.removeAll()
        daySchedule.removeAll()
        selectedIndex = -1
        m = viewModel.MinusMonth(m: self.m)
        self.currentSchedule = viewModel.FindcurrentSchedule()
        self.currentDays = viewModel.FindcurrentDays(currentSchedule: self.currentSchedule)
        collectionView.reloadData()
        setMonthView()
        
        
    }
    
    @IBAction func nextMonth(_ sender: UIButton) {
        selectedDate = CalendarHelper().plusMonth(date: selectedDate)
        selectedIndex = -1
        m = viewModel.PlusMonth(m: self.m)
        currentDays.removeAll()
        currentSchedule.removeAll()
        daySchedule.removeAll()
        self.currentSchedule = viewModel.FindcurrentSchedule()
        self.currentDays = viewModel.FindcurrentDays(currentSchedule: self.currentSchedule)
        setMonthView()
    }
    
    override open var shouldAutorotate: Bool{ // 화면 방향전환여부 x
        return false
    }
}

extension MeViewController {
    func setBinding(){
        viewModel.$userinfo.sink{ (userinfo : userstruct) in
            print("setbinding")
            self.userinfo = userinfo
            scheduleList.removeAll()
            viewModel.AddScheduleList()
            self.currentDays.removeAll()
            self.currentSchedule.removeAll()
            self.currentSchedule = viewModel.FindcurrentSchedule()
            print("currentSchedule")
            for i in self.currentSchedule{
                print(i.title)
            }
            self.currentDays = viewModel.FindcurrentDays(currentSchedule: self.currentSchedule)
            print("currentDays")
            for i in self.currentDays{
                print(i)
            }
            self.collectionView.reloadData()
            self.ScheduleTable.reloadData()
        }.store(in: &disposalblebag)
    }
    
}

//컬렉션부
extension MeViewController{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { // 지정된 섹션에 표시할 셀의 개수를 묻는 함수
        return totalSquares.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { // 컬렉션뷰의 지정된 위치에 표시할 셀을 요청하는 함수
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseCell", for: indexPath) as! CalendarCell // 재사용되는 셀의 속성 초기화
        var year = CalendarHelper().yearString(date: selectedDate) // string
        var month = CalendarHelper().monthString(date: selectedDate) // string
        var day = totalSquares[indexPath.item] // string
        let yearMonthDay = year + "년 " + month + "월 " + day + "일"
        let date = totalSquares[indexPath.item]
        
        
        
        cell.dayLabel.text = date
        cell.scheduleOn.layer.cornerRadius = cell.scheduleOn.frame.width / 2
        cell.scheduleOn.clipsToBounds = true
        cell.scheduleOn.backgroundColor = .white
        
        for i in currentDays{
            if(date == String(i)){
                cell.scheduleOn.backgroundColor = .blue
            }
        }
                
        if(selectedIndex == indexPath.row){
            cell.layer.borderWidth = 0.5
        }
        else{
            cell.layer.borderWidth = 0
        }
        
        return cell
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var year = CalendarHelper().yearString(date: selectedDate) // string
        var month = CalendarHelper().monthString(date: selectedDate) // string
        var day = totalSquares[indexPath.item] // string
        
        let date = year + "년 " + month + "월 " + day + "일"
        
        selectedDate = CalendarHelper().StringtoDate(string: date)
        selectedIndex = indexPath.row
        daySchedule.removeAll()
        print(day)
        if (day != " "){
            self.daySchedule = viewModel.FindDaySchedule(currentSchedule: self.currentSchedule, day: day)
            collectionView.reloadData()
            ScheduleTable.reloadData()
        }
    }
}

//테이블부
extension MeViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return scheduleList.count
        
        return daySchedule.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ScheduleTable.dequeueReusableCell(withIdentifier: "Cells", for: indexPath) as! Cells
        cell.Txt.text = daySchedule[indexPath.row].title
                
        var currentDay = CalendarHelper().dateToString(date: selectedDate)
        var currentYear = CalendarHelper().yearString(date: selectedDate)
        var startYear = CalendarHelper().yearString(date: CalendarHelper().StringtoDate(string: daySchedule[indexPath.row].startDate))
        var endYear = CalendarHelper().yearString(date: CalendarHelper().StringtoDate(string: daySchedule[indexPath.row].endDate))
        var startDay = daySchedule[indexPath.row].startDate
        var endDay = daySchedule[indexPath.row].endDate
        

        if(currentDay == startDay && currentDay == endDay){
            cell.subTitle.text = daySchedule[indexPath.row].startTime + " ~ " + daySchedule[indexPath.row].endTime
        }
        else if(currentDay != startDay && currentDay != endDay){
            cell.subTitle.text = "하루종일"
        }
        else if(currentDay == startDay){
            cell.subTitle.text = daySchedule[indexPath.row].startTime + " ~ "
        }
        else{
            cell.subTitle.text =  " ~ " + daySchedule[indexPath.row].endTime
        }

        return cell
    }
}

// 뷰 관련 함수
extension MeViewController{
    func setCellsView(){
        let width = (UIScreen.main.bounds.width) / 7
        let screenHeight = (UIScreen.main.bounds.height) * 2 / 5
        let height = screenHeight / 6
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: width, height: height)
    }
    
    func setMonthView(){ // 달력 나타내기
        totalSquares.removeAll()
        
        let daysInMonth = CalendarHelper().daysInMonth(date: selectedDate)
        let firstDayOfMonth = CalendarHelper().firstOfMonth(date: selectedDate)
        let startingSpaces = CalendarHelper().weekDay(date: firstDayOfMonth)
        
        var count: Int = 1
        
        
        while(count <= 42){
            if(count <= startingSpaces || count - startingSpaces > daysInMonth){
                totalSquares.append(" ")
            }
            else{

                totalSquares.append(String(count - startingSpaces))
            }
            count+=1
        }

        monthLabel.text = CalendarHelper().yearString(date: selectedDate) + "년 " + CalendarHelper().monthString(date: selectedDate) + "월"
        
        collectionView.reloadData()
        ScheduleTable.reloadData()
    }
}


