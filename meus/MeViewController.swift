import Firebase
import FirebaseDatabase
import CodableFirebase
import UIKit

var selectedDate = Date()

class MeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    var uid = Auth.auth().currentUser?.uid
    var ref : DatabaseReference!
    var currentSchedule:[Schedule] = []     // 그 달의 모든 스케줄
    var daySchedule:[Schedule] = []         // 그 날의 스케쥴
    var currentDays:[Int] = []              // 그 달의 스케줄이 있는 날짜들
    var selectedIndex = -1
    var userinfo : userstruct!
    
    @IBOutlet var backbutton: UIButton!
    @IBOutlet var Calendarname: UILabel!
    @IBOutlet var addbutton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet var ScheduleTable: UITableView!

    var totalSquares = [String]()
    
    var m: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("viewdidload")
        
        ref = Database.database().reference()
       
        m = Int(CalendarHelper().monthString(date: selectedDate))!
        Loaduser{data in
            self.userinfo = data
            scheduleList.removeAll()
            for i in self.userinfo.schedules{
                var newschedule:Schedule = Schedule(title: i[0], startDate: i[1], endDate: i[2], startTime: i[3], endTime: i[4])
                scheduleList.append(newschedule)
            }
            for i in scheduleList{
                var aa = Int(CalendarHelper().monthString(date: CalendarHelper().StringtoDate(string: i.startDate)))!
                
                if (aa == self.m){
                    self.currentSchedule.append(i)
                    var bb = CalendarHelper().daysOfMonth(date: CalendarHelper().StringtoDate(string: i.startDate))
                    var cc = CalendarHelper().daysOfMonth(date: CalendarHelper().StringtoDate(string: i.endDate))
                    for i in bb...cc{
                        if(!self.currentDays.contains(i)){
                            self.currentDays.append(i)
                        }
                    }

                    
                }
            }
            self.collectionView.reloadData()
        }
        
        
//        scheduleList.append(schedule1)
//        scheduleList.append(schedule2)
//        scheduleList.append(schedule3)
       
        
        self.navigationItem.hidesBackButton = true
        setCellsView()
        setMonthView()
        collectionView.delegate = self
        collectionView.dataSource = self
        ScheduleTable.dataSource = self
        ScheduleTable.delegate = self
    }
    
    
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
        selectedIndex = -1
        currentDays.removeAll()
        currentSchedule.removeAll()
        daySchedule.removeAll()
        m -= 1
        if(m == 0){
            m = 12
        }
        for i in scheduleList{
            var aa = Int(CalendarHelper().monthString(date: CalendarHelper().StringtoDate(string: i.startDate)))!
            
            if (aa == m){
                currentSchedule.append(i)
                var bb = CalendarHelper().daysOfMonth(date: CalendarHelper().StringtoDate(string: i.startDate))
                var cc = CalendarHelper().daysOfMonth(date: CalendarHelper().StringtoDate(string: i.endDate))
                for i in bb...cc{
                    if(!currentDays.contains(i)){
                        currentDays.append(i)
                    }
                }

                
            }
        }
        collectionView.reloadData()
        setMonthView()
        
        
    }
    
    @IBAction func nextMonth(_ sender: UIButton) {
        selectedDate = CalendarHelper().plusMonth(date: selectedDate)
        selectedIndex = -1
        m += 1
        if(m == 13){
            m = 1
        }
        
        currentDays.removeAll()
        currentSchedule.removeAll()
        daySchedule.removeAll()
        
        for i in scheduleList{
            var aa = Int(CalendarHelper().monthString(date: CalendarHelper().StringtoDate(string: i.startDate)))!
            
            if (aa == m){
                currentSchedule.append(i)
                var bb = CalendarHelper().daysOfMonth(date: CalendarHelper().StringtoDate(string: i.startDate))
                var cc = CalendarHelper().daysOfMonth(date: CalendarHelper().StringtoDate(string: i.endDate))
                for i in bb...cc{
                    if(!currentDays.contains(i)){
                        currentDays.append(i)
                    }
                }
                
            }
        }
        setMonthView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { // 지정된 섹션에 표시할 셀의 개수를 묻는 함수
        totalSquares.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { // 컬렉션뷰의 지정된 위치에 표시할 셀을 요청하는 함수
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseCell", for: indexPath) as! CalendarCell // 재사용되는 셀의 속성 초기화
      
        
        
        var year = CalendarHelper().yearString(date: selectedDate) // string
        var month = CalendarHelper().monthString(date: selectedDate) // string
        var day = totalSquares[indexPath.item] // string
        let yearMonthDay = year + "년 " + month + "월 " + day + "일"

        let date = totalSquares[indexPath.item]
        
        cell.dayLabel.text = date
        //cell.backgroundColor = .white
        cell.scheduleOn.layer.cornerRadius = cell.scheduleOn.frame.width / 2
        cell.scheduleOn.clipsToBounds = true
        cell.scheduleOn.backgroundColor = .white
        for i in currentDays{
            if(date == String(i)){
                //cell.backgroundColor = .blue
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
        if (day != " "){
            selectedDate = CalendarHelper().StringtoDate(string: date)
            selectedIndex = indexPath.row
            daySchedule.removeAll()
            for i in currentSchedule{
                var bb = CalendarHelper().daysOfMonth(date: CalendarHelper().StringtoDate(string: i.startDate))
                var cc = CalendarHelper().daysOfMonth(date: CalendarHelper().StringtoDate(string: i.endDate))
                if(Int(day)! >= bb && Int(day)! <= cc){
                    daySchedule.append(i)
                }
            }
            
            collectionView.reloadData()
            ScheduleTable.reloadData()
        }
    }
    

    
    override open var shouldAutorotate: Bool{ // 화면 방향전환여부 x
        return false
    }
    
    /// Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return scheduleList.count
        
        return daySchedule.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ScheduleTable.dequeueReusableCell(withIdentifier: "Cells", for: indexPath) as! Cells
        cell.Txt.text = daySchedule[indexPath.row].title
        
        
        if(CalendarHelper().dateToString(date: selectedDate) == daySchedule[indexPath.row].endDate && CalendarHelper().dateToString(date: selectedDate) == daySchedule[indexPath.row].startDate){
            cell.subTitle.text = daySchedule[indexPath.row].startTime + " ~ " + daySchedule[indexPath.row].endTime
        }
        else if(CalendarHelper().dateToString(date: selectedDate) != daySchedule[indexPath.row].endDate && CalendarHelper().dateToString(date: selectedDate) != daySchedule[indexPath.row].startDate){
            cell.subTitle.text = "하루종일"
        }
        else if(CalendarHelper().dateToString(date: selectedDate) == daySchedule[indexPath.row].startDate){
            cell.subTitle.text = daySchedule[indexPath.row].startTime + " ~ "
        }
        else{
            cell.subTitle.text =  " ~ " + daySchedule[indexPath.row].endTime
        }

        return cell
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("viewdidappear")
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
            Loaduser{data in
                self.userinfo = data
                scheduleList.removeAll()
                self.currentDays.removeAll()
                self.currentSchedule.removeAll()
                for i in self.userinfo.schedules{
                    var newschedule:Schedule = Schedule(title: i[0], startDate: i[1], endDate: i[2], startTime: i[3], endTime: i[4])
                    scheduleList.append(newschedule)
                }
                for i in scheduleList{
                    var aa = Int(CalendarHelper().monthString(date: CalendarHelper().StringtoDate(string: i.startDate)))!
                    
                    if (aa == self.m){
                        self.currentSchedule.append(i)
                        var bb = CalendarHelper().daysOfMonth(date: CalendarHelper().StringtoDate(string: i.startDate))
                        var cc = CalendarHelper().daysOfMonth(date: CalendarHelper().StringtoDate(string: i.endDate))
                        for i in bb...cc{
                            if(!self.currentDays.contains(i)){
                                self.currentDays.append(i)
                            }
                        }
                    }
                }
                self.collectionView.reloadData()
            }
        }
        
        
    }
}

extension MeViewController {
    func Loaduser(completion: @escaping (userstruct) -> ()) {
       
        
        ref.child("users").child(uid ?? "anyvalue").getData {
            (error, snapshot) in
            if let error = error {
                print("Error \(error)")
            }
            else {
                let value = snapshot?.value
                if let data = try? FirebaseDecoder().decode(userstruct.self, from: value){
                    
                    completion(data)
//                    DispatchQueue.main.async {
//                        self.collectionView.reloadData()
//                    }
                }
                else {
                    print("Error")
                }
            }
        }
    }
}

