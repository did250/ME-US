import Firebase
import UIKit
import CodableFirebase
import FirebaseDatabase
import Combine

var scheduleList2 = [Schedule]() // 그룹 내의 사람들의 스케줄을 다 받아오는 곳

class MixedScheduleViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var ref : DatabaseReference!
    var userinfo = userstruct(Frequest: [""], Grequest: [""], friends: [""], groups: [""], id: "", key: "", name: "", schedules: [[""]], uid: "")
    
    var disposalblebag = Set<AnyCancellable>()
    
    var visitedArr = [Bool](repeating: false, count: 1440) // 꽉 차있으면 또 처리할 필요없게
    var currentDate: String = ""
    var todayDate = Date()
    
    var d: Int = 0
    var m: Int = 0
    var y: Int = 0
    
    @IBOutlet weak var datePicker: UIDatePicker!

    @IBOutlet weak var pmStackView: UIStackView!
    @IBOutlet weak var mixedScheduleTableView: UITableView!
    @IBOutlet weak var mixedScheduleTableView2: UITableView!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureStartDatePicker()
        self.timeLabel.layer.borderWidth = 0.5
        
        var schedule0 = Schedule(title: "a0", startDate: "2022년 7월 2일", endDate: "2022년 7월 2일", startTime: "오후 5시 10분", endTime: "오후 8시 50분")
        var schedule1 = Schedule(title: "a5", startDate: "2022년 7월 3일", endDate: "2022년 7월 3일", startTime: "오전 7시 20분", endTime: "오후 3시 59분")
        var schedule2 = Schedule(title: "a1", startDate: "2022년 7월 3일", endDate: "2022년 7월 3일", startTime: "오후 5시 20분", endTime: "오후 7시 40분")
        var schedule3 = Schedule(title: "a2", startDate: "2022년 6월 18일", endDate: "2022년 6월 22일", startTime: "오전 11시 20분", endTime: "오전 8시 40분")
        //var schedule4 = Schedule(title: "a3", startDate: "2022년 7월 21일", endDate: "2022년 10월 7일", startTime: "오전 11시 20분", endTime: "오전 11시 20분")
        var schedule5 = Schedule(title: "a4", startDate: "2022년 11월 23일", endDate: "2023년 2월 3일", startTime: "오전 11시 20분", endTime: "오전 11시 20분")
        


        scheduleList2.append(schedule0)
        scheduleList2.append(schedule1)
        scheduleList2.append(schedule2)
        scheduleList2.append(schedule3)
//        scheduleList2.append(schedule4)
        scheduleList2.append(schedule5)
        
        self.mixedScheduleTableView.isScrollEnabled = false
        self.mixedScheduleTableView.separatorStyle = .none
        self.mixedScheduleTableView.dataSource = self
        self.mixedScheduleTableView.delegate = self
        self.mixedScheduleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MixedSceduleTableViewCell")
        self.mixedScheduleTableView2.isScrollEnabled = false
        self.mixedScheduleTableView2.separatorStyle = .none
        self.mixedScheduleTableView2.dataSource = self
        self.mixedScheduleTableView2.delegate = self
        self.mixedScheduleTableView2.register(UITableViewCell.self, forCellReuseIdentifier: "MixedSceduleTableViewCell")
        
        self.findMixedSchedule()
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(pmStackView.bounds.height / 720)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == mixedScheduleTableView){
            return 720
        }
        if(tableView == mixedScheduleTableView2){
            return 720
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mixedScheduleTableView.dequeueReusableCell(withIdentifier: "MixedSceduleTableViewCell", for: indexPath)
        cell.selectionStyle = .none

        if(tableView == mixedScheduleTableView){
            cell.backgroundColor = .white
        }
        if(tableView == mixedScheduleTableView2){
            cell.backgroundColor = .white
        }
        
        if(tableView == mixedScheduleTableView){
            if(visitedArr[indexPath.row] == true){
                cell.backgroundColor = .black
            }
        }
        if(tableView == mixedScheduleTableView2){
            if(visitedArr[indexPath.row + 720] == true){
                cell.backgroundColor = .black
            }
        }
        

        return cell
    }
    
   
    
    
    private func configureStartDatePicker(){
        self.datePicker.datePickerMode = .date
        self.datePicker.date = todayDate
        self.datePicker.preferredDatePickerStyle = .wheels
        self.datePicker.addTarget(self, action: #selector(startDatePickerValueDidChange(_:)), for: .valueChanged)
        
        self.currentDate = CalendarHelper().dateToString(date: datePicker.date)
        mixedScheduleTableView.reloadData()
        
    }
    @objc private func startDatePickerValueDidChange(_ datePicker: UIDatePicker){
        let formater = DateFormatter()
        formater.dateFormat = "yyyy년 MM월 dd일"
        formater.locale = Locale(identifier: "ko_KR")
        
        self.currentDate = CalendarHelper().dateToString(date: datePicker.date)
        self.findMixedSchedule()
        for i in 0...1439{
            if(visitedArr[i] == true){
                print(i)
            }
        }
        self.mixedScheduleTableView.reloadData()
        self.mixedScheduleTableView2.reloadData()
    }
    
    
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    func findMixedSchedule(){
        d = Int(CalendarHelper().dayToString(date: datePicker.date))!
        m = Int(CalendarHelper().monthString(date: datePicker.date))!
        y = Int(CalendarHelper().yearString(date: datePicker.date))!
        visitedArr = [Bool](repeating: false, count: 1440)
        for i in scheduleList2{
            if(!visitedArr.contains(false)){
                break
            }
            
        
            var startYear = Int(CalendarHelper().yearString(date: CalendarHelper().StringtoDate(string: i.startDate)))!
            var endYear = Int(CalendarHelper().yearString(date: CalendarHelper().StringtoDate(string: i.endDate)))!
            var startMonth = Int(CalendarHelper().monthString(date: CalendarHelper().StringtoDate(string: i.startDate)))!
            var endMonth = Int(CalendarHelper().monthString(date: CalendarHelper().StringtoDate(string: i.endDate)))!
            var startDay = Int(CalendarHelper().dayToString(date: CalendarHelper().StringtoDate(string: i.startDate)))!
            var endDay = Int(CalendarHelper().dayToString(date: CalendarHelper().StringtoDate(string: i.endDate)))!
            var startMeridiem = CalendarHelper().ampmToString(date: CalendarHelper().StringtoTime(string: i.startTime))
            var endMeridiem = CalendarHelper().ampmToString(date: CalendarHelper().StringtoTime(string: i.endTime))
            var startHour = CalendarHelper().hourToString(date: CalendarHelper().StringtoTime(string: i.startTime))
            var endHour = CalendarHelper().hourToString(date: CalendarHelper().StringtoTime(string: i.endTime))
            var startMin = CalendarHelper().minToString(date: CalendarHelper().StringtoTime(string: i.startTime))
            var endMin = CalendarHelper().minToString(date: CalendarHelper().StringtoTime(string: i.endTime))
            var startTimeToNum: Int
            var endTimeToNum: Int
            
            if(startMeridiem == "오전"){
                if(startHour == "12"){
                    startTimeToNum = Int(startMin)!
                }
                else{
                    startTimeToNum = Int(startHour)! * 60 + Int(startMin)!
                }
                
            }
            else{
                if(startHour == "12"){
                    startTimeToNum = 720 + Int(startMin)!
                }
                else{
                    startTimeToNum = 720 + Int(startHour)! * 60 + Int(startMin)!
                }
                
            }
            if(endMeridiem == "오전"){
                if(endHour == "12"){
                    endTimeToNum = Int(endMin)!
                }
                else{
                    endTimeToNum = Int(endHour)! * 60 + Int(endMin)!
                }
            }
            else{
                if(endHour == "12"){
                    endTimeToNum = 720 + Int(endMin)!
                }
                else{
                    endTimeToNum = 720 + Int(endHour)! * 60 + Int(endMin)!
                }
            }
            if(startYear == self.y && endYear == self.y){
                if(startMonth == self.m && endMonth == self.m){
                    if(startDay == self.d && endDay == self.d){
                        for i in startTimeToNum...endTimeToNum{
                            visitedArr[i] = true
                            
                        }
                        
                    }
                    else if(startDay <= self.d && endDay >= self.d){
                        if(startDay == self.d){
                            for i in startTimeToNum...1439{
                                visitedArr[i] = true
                            }
                        }
                        else if(startDay < self.d && endDay > self.d){
                            for i in 0...1439{
                                visitedArr[i] = true
                            }
                            break
                        }
                        else if(endDay == self.d){
                            for i in 0...endTimeToNum{
                                visitedArr[i] = true
                            }
                        }
                    }

                }
                else if(startMonth <= self.m && endMonth >= self.m){
                    if(startMonth == self.m){
                        if(startDay == self.d){
                            for i in startTimeToNum...1439{
                                visitedArr[i] = true
                            }
                        }
                        else if(startDay < self.d){
                            for i in 0...1439{
                                visitedArr[i] = true
                            }
                            break
                        }
                    }
                    else if(startMonth < self.m && endMonth > self.m){
                        for i in 1...1439{
                            visitedArr[i] = true
                        }
                        break
                    }
                    else if(endMonth == self.m){
                        if(endDay > self.d){
                            for i in 0...1439{
                                visitedArr[i] = true
                            }
                            break
                        }
                        else if(endDay == self.d){
                            for i in 0...endTimeToNum{
                                visitedArr[i] = true
                            }
                        }
                    }
                }
            }
            else if(startYear <= self.y && endYear >= self.y){
                if(startYear == self.y){
                    if(startMonth == self.m){
                        if(startDay == self.d){
                            for i in startTimeToNum...1439{
                                visitedArr[i] = true
                            }
                        }
                        else if(startDay < self.d){
                            for i in 0...1439{
                                visitedArr[i] = true
                            }
                            break
                        }
                    }
                    else if(startMonth < self.m){
                        for i in 0...1439{
                            visitedArr[i] = true
                        }
                        break
                    }
                    
                }
                else if(startYear < self.y && endYear > self.y){
                    for i in 0...1439{
                        visitedArr[i] = true
                    }
                    break
                }
                else if(endYear == self.y){
                    if(endMonth == self.m){
                        if(endDay > self.d){
                            for i in 0...1439{
                                visitedArr[i] = true
                            }
                            break
                        }
                        else if(endDay == self.d){
                            for i in 0...endTimeToNum{
                                visitedArr[i] = true
                            }
                        }
                    }
                    else if(endMonth > self.m){
                        for i in 0...1439{
                            visitedArr[i] = true
                        }
                        break

                    }
                }
            }
        }//for문 끝나는곳
    }
    
}

extension MixedScheduleViewController {
    func setBinding(){
        viewModel.$userinfo.sink{ (userinfo : userstruct) in
            self.userinfo = userinfo
            self.mixedScheduleTableView.reloadData()
            self.mixedScheduleTableView2.reloadData()
        }.store(in: &disposalblebag)
    }
}
