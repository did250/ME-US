import Foundation
import Combine
import Firebase
import FirebaseDatabase
import CodableFirebase

class ViewModel: ObservableObject {
    
    var ref : DatabaseReference = Database.database().reference()
    
    @Published var userinfo : userstruct = userstruct(Frequest: [""], Grequest: [""], friends: [""], groups: ["1"], id: "1", key: "", name: "0", schedules: [[""]], uid: "")
    
    init(){
        print("VM init")
    }
}

extension ViewModel {
    
    
    func login( userEmail: String, userPassword: String, completion : @escaping (Int) -> ()){
        return Auth.auth().signIn(withEmail: userEmail, password: userPassword) { [weak self] authResult, error in guard self != nil else { return }
            if authResult != nil {
                let flag = 1
                completion(flag)
            }
            else {
                let flag = 2
                completion(flag)
            }
            
        }
    }
    func Loaduser(uid: String, completion: @escaping (userstruct) -> ()){
        
        ref.child("users").child(uid ?? "anyvalue").getData {
            (error, snapshot) in
            if let error = error {
                print("Error \(error)")
            }
            else {
                let value = snapshot?.value
                if let data = try? FirebaseDecoder().decode(userstruct.self, from: value){
                    self.userinfo = data
                    
                    completion(data)
                }
                else {
                    print("Error")
                }
            }
        }
    }
    func AddGroup(new: String, completion: @escaping (Int)->()){
        self.userinfo.groups.append(new)
        self.ref.child("users").child(self.userinfo.uid).updateChildValues(["groups": self.userinfo.groups])
        completion(1)
    }
    
    func sendFrequest(friendid : String, flag : String, completion: @escaping (Int) -> ()) {
        var frienduid : String = ""
        self.ref.child("users").queryOrdered(byChild: "id").queryEqual(toValue: friendid).observeSingleEvent(of: .value, with: {
            snapshot in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                frienduid = snap.key
                if flag == "GroupInvite" {
                    self.ref.child("users").child(frienduid).child("Grequest").getData {
                        (error,snapshot) in
                        if let error = error {
                            print("Error \(error)")
                        }
                        else{
                            guard let value = snapshot?.value else {return}
                            print(value)
                            if let data2 = try? FirebaseDecoder().decode([String].self, from: value){
                                var array: [String] = data2
                                if (!array.contains(self.userinfo.id)){
                                    array.append(self.userinfo.id)
                                    self.ref.child("users").child(frienduid).updateChildValues(["Grequest": array])
                                    completion(1)
                                   
                                }
                                else {
                                    completion(2)
                                }
                            }
                            else{
                                print("Error")
                            }
                        }
                    }
                }
                else{
                    self.ref.child("users").child(frienduid).child("Frequest").getData {
                        (error,snapshot) in
                        if let error = error {
                            print("Error \(error)")
                        }
                        else{
                            guard let value = snapshot?.value else {return}
                            if let data2 = try? FirebaseDecoder().decode([String].self, from: value){
                                var array: [String] = data2
                                if (!array.contains(self.userinfo.id)){
                                    array.append(self.userinfo.id)
                                    self.ref.child("users").child(frienduid).updateChildValues(["Frequest": array])
                                    completion(3)
                                }
                                else {
                                    completion(4)
                                }
                            }
                            else{
                                print("Error")
                            }
                        }
                    }
                }
            }
        })
    }
    
    func AcceptFriend(target: String, completion: @escaping (Int) -> ()) {
        var frienduid : String = ""
        self.ref.child("users").queryOrdered(byChild: "id").queryEqual(toValue: target).observeSingleEvent(of: .value, with: {
            snapshot in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                frienduid = snap.key
                self.ref.child("users").child(frienduid).child("friends").getData {
                    (error,snapshot) in
                    if let error = error {
                        print("Error \(error)")
                    }
                    else{
                        guard let value = snapshot?.value else {return}
                        if let data2 = try? FirebaseDecoder().decode([String].self, from: value){
                            var array: [String] = data2
                            if (!array.contains(self.userinfo.id)){
                                array.append(self.userinfo.id)
                                self.ref.child("users").child(frienduid).updateChildValues(["friends": array])
                                self.userinfo.friends.append(target)
                                self.userinfo.Frequest.remove(at: self.userinfo.Frequest.firstIndex(of: target)!)
                                self.ref.child("users").child(self.userinfo.uid).updateChildValues(["friends": self.userinfo.friends])
                                self.ref.child("users").child(self.userinfo.uid).updateChildValues(["Frequest": self.userinfo.Frequest])
                                completion(1)
                            }
                            else {
                                completion(2)
                            }
                        }
                        else{
                            print("Error")
                        }
                    }
                }
            }
        })
    }
    
    func DenyFriend(target: String){
        self.userinfo.Frequest.remove(at: self.userinfo.Frequest.firstIndex(of: target)!)
        self.ref.child("users").child(self.userinfo.uid).updateChildValues(["Frequest": self.userinfo.Frequest])
    }
    
    func AcceptGroup(target: String, completion: @escaping (Int) -> ()) {
            completion(1)
        
    }
    
    func DenyGroup(target: String){
        self.userinfo.Grequest.remove(at: self.userinfo.Grequest.firstIndex(of: target)!)
        self.ref.child("users").child(self.userinfo.uid).updateChildValues(["Grequest": self.userinfo.Grequest])
    }
    
    func FindFriend(name : String ,completion: @escaping (String)->()){
        var frienduid : String = ""
        self.ref.child("users").queryOrdered(byChild: "id").queryEqual(toValue: name).observeSingleEvent(of: .value, with: {
            snapshot in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                frienduid = snap.key
                completion(frienduid)
            }
        })
    }
    
    //cell에서 x버튼
    func DeleteSchedule(target: String){
        for i in self.userinfo.schedules.startIndex...self.userinfo.schedules.endIndex-1{
            if(self.userinfo.schedules[i][0] == target){
                print("123")
                self.userinfo.schedules.remove(at: i)
                print("456")
                break
            }
        }
        print(self.userinfo.schedules)
        self.ref.child("users").child(self.userinfo.uid).updateChildValues(["schedules":self.userinfo.schedules])
        print("adfk;asdjfkladsjfl;asdfjla;dsjfl")
        
//        var currentDays = MeViewController().currentDays
//        var currentSchedule = MeViewController().currentSchedule
//        currentDays.removeAll()
//        currentSchedule.removeAll()
//        currentSchedule = viewModel.FindcurrentSchedule()
//        currentDays = viewModel.FindcurrentDays(currentSchedule: currentSchedule)
//
//        // 위에 4줄 이렇게 해버려도 되나?????????????
//
//        MeViewController().collectionView.reloadData()
//        MeViewController().ScheduleTable.reloadData()
    }
    
    func FindcurrentDays(currentSchedule:[Schedule]) -> [Int]{
        var m: Int
        var y: Int
        m = Int(CalendarHelper().monthString(date: selectedDate))!
        y = Int(CalendarHelper().yearString(date: selectedDate))!
        var currentDays:[Int] = []              // 그 달의 스케줄이 있는 날짜들
        for i in currentSchedule{
            var startYear = Int(CalendarHelper().yearString(date: CalendarHelper().StringtoDate(string: i.startDate)))!
            var endYear = Int(CalendarHelper().yearString(date: CalendarHelper().StringtoDate(string: i.endDate)))!
            var startMonth = Int(CalendarHelper().monthString(date: CalendarHelper().StringtoDate(string: i.startDate)))!
            var endMonth = Int(CalendarHelper().monthString(date: CalendarHelper().StringtoDate(string: i.endDate)))!
            
            if(startYear == y && endYear == y){
                if(startMonth == m && endMonth == m){
                    var startDay = CalendarHelper().daysOfMonth(date: CalendarHelper().StringtoDate(string: i.startDate))
                    var endDay = CalendarHelper().daysOfMonth(date: CalendarHelper().StringtoDate(string: i.endDate))
                    for i in startDay...endDay{
                        if(!currentDays.contains(i)){
                            currentDays.append(i)
                        }
                    }
                }
                else if(startMonth <= m && endMonth >= m){
                    if(startMonth == m){
                        var startDay = CalendarHelper().daysOfMonth(date: CalendarHelper().StringtoDate(string: i.startDate))
                        var endDay = CalendarHelper().daysInMonth(date: CalendarHelper().StringtoDate(string: i.startDate))
                        for i in startDay...endDay{
                            if(!currentDays.contains(i)){
                                currentDays.append(i)
                            }
                        }
                        
                    }
                    else if(startMonth < m && endMonth > m){
                        var startDay = 1
                        var endDay = CalendarHelper().daysInMonth(date: selectedDate)
                        for i in startDay...endDay{
                            if(!currentDays.contains(i)){
                                currentDays.append(i)
                            }
                        }
                    }
                    else if(endMonth == m){
                        var startDay = 1
                        var endDay = CalendarHelper().daysOfMonth(date: CalendarHelper().StringtoDate(string: i.endDate))
                        for i in startDay...endDay{
                            if(!currentDays.contains(i)){
                                currentDays.append(i)
                            }
                        }
                    }
                }
            }
            else if(startYear <= y && endYear >= y){
                if(startYear == y){
                    if(startMonth == m){
                        var startDay = CalendarHelper().daysOfMonth(date: CalendarHelper().StringtoDate(string: i.startDate))
                        var endDay = CalendarHelper().daysInMonth(date: CalendarHelper().StringtoDate(string: i.startDate))
                        for i in startDay...endDay{
                            if(!currentDays.contains(i)){
                                currentDays.append(i)
                            }
                        }
                    }
                    else if(startMonth < m){
                        var startDay = 1
                        var endDay = CalendarHelper().daysInMonth(date: selectedDate)
                        for i in startDay...endDay{
                            if(!currentDays.contains(i)){
                                currentDays.append(i)
                            }
                        }
                    }
                }
                else if(startYear < y && endYear > y){
                    var startDay = 1
                    var endDay = CalendarHelper().daysInMonth(date: selectedDate)
                    for i in startDay...endDay{
                        if(!currentDays.contains(i)){
                            currentDays.append(i)
                        }
                    }
                }
                else if(endYear == y){
                    if(endMonth == m){
                        var startDay = 1
                        var endDay = CalendarHelper().daysOfMonth(date: CalendarHelper().StringtoDate(string: i.endDate))
                        for i in startDay...endDay{
                            if(!currentDays.contains(i)){
                                currentDays.append(i)
                            }
                        }
                    }
                    else if(endMonth > m){
                        var startDay = 1
                        var endDay = CalendarHelper().daysInMonth(date: selectedDate)
                        for i in startDay...endDay{
                            if(!currentDays.contains(i)){
                                currentDays.append(i)
                            }
                        }

                    }
                }
            }
        }//for문 끝나는곳
        return currentDays
    }
    
    func FindcurrentSchedule() -> [Schedule]{
        var m: Int
        var y: Int
        m = Int(CalendarHelper().monthString(date: selectedDate))!
        y = Int(CalendarHelper().yearString(date: selectedDate))!
        var currentSchedule:[Schedule] = []     // 그 달의 모든 스케줄
        
        for i in scheduleList{
            var startYear = Int(CalendarHelper().yearString(date: CalendarHelper().StringtoDate(string: i.startDate)))!
            var endYear = Int(CalendarHelper().yearString(date: CalendarHelper().StringtoDate(string: i.endDate)))!
            var startMonth = Int(CalendarHelper().monthString(date: CalendarHelper().StringtoDate(string: i.startDate)))!
            var endMonth = Int(CalendarHelper().monthString(date: CalendarHelper().StringtoDate(string: i.endDate)))!
            
            if(startYear == y && endYear == y){
                if(startMonth == m && endMonth == m){
                    currentSchedule.append(i)
                    
                }
                else if(startMonth <= m && endMonth >= m){
                    if(startMonth == m){
                        currentSchedule.append(i)
                    }
                    else if(startMonth < m && endMonth > m){
                        currentSchedule.append(i)
                    }
                    else if(endMonth == m){
                        currentSchedule.append(i)
                    }
                }
            }
            else if(startYear <= y && endYear >= y){
                if(startYear == y){
                    if(startMonth == m){
                        currentSchedule.append(i)
                    }
                    else if(startMonth < m){
                        currentSchedule.append(i)
                    }
                }
                else if(startYear < y && endYear > y){
                    currentSchedule.append(i)

                }
                else if(endYear == y){
                    if(endMonth == m){
                        currentSchedule.append(i)
                    }
                    else if(endMonth > m){
                        currentSchedule.append(i)
                    }
                }
            }
        }//for문 끝나는곳
        return currentSchedule
    }
    
    func FindDaySchedule(currentSchedule: [Schedule], day: String) -> [Schedule]{
        var m: Int
        var y: Int
        m = Int(CalendarHelper().monthString(date: selectedDate))!
        y = Int(CalendarHelper().yearString(date: selectedDate))!
        var daySchedule:[Schedule] = []         // 그 날의 스케쥴
        
        for i in currentSchedule{
            var startYear = Int(CalendarHelper().yearString(date: CalendarHelper().StringtoDate(string: i.startDate)))!
            var endYear = Int(CalendarHelper().yearString(date: CalendarHelper().StringtoDate(string: i.endDate)))!
            var startMonth = Int(CalendarHelper().monthString(date: CalendarHelper().StringtoDate(string: i.startDate)))!
            var endMonth = Int(CalendarHelper().monthString(date: CalendarHelper().StringtoDate(string: i.endDate)))!
            
            if(startYear == y && endYear == y){
                if(startMonth == m && endMonth == m){
                    var startDay = CalendarHelper().daysOfMonth(date: CalendarHelper().StringtoDate(string: i.startDate))
                    var endDay = CalendarHelper().daysOfMonth(date: CalendarHelper().StringtoDate(string: i.endDate))
                    if(Int(day)! >= startDay && Int(day)! <= endDay){
                        daySchedule.append(i)
                    }
                }
                else if(startMonth <= m && endMonth >= m){
                    if(startMonth == m){
                        var startDay = CalendarHelper().daysOfMonth(date: CalendarHelper().StringtoDate(string: i.startDate))
                        var endDay = CalendarHelper().daysInMonth(date: CalendarHelper().StringtoDate(string: i.startDate))
                        if(Int(day)! >= startDay && Int(day)! <= endDay){
                            daySchedule.append(i)
                        }
                    }
                    else if(startMonth < m && endMonth > m){
                        var startDay = 1
                        var endDay = CalendarHelper().daysInMonth(date: selectedDate)
                        if(Int(day)! >= startDay && Int(day)! <= endDay){
                            daySchedule.append(i)
                        }
                    }
                    else if(endMonth == m){
                        var startDay = 1
                        var endDay = CalendarHelper().daysOfMonth(date: CalendarHelper().StringtoDate(string: i.endDate))
                        if(Int(day)! >= startDay && Int(day)! <= endDay){
                            daySchedule.append(i)
                        }
                    }
                }
            }
            else if(startYear <= y && endYear >= y){
                if(startYear < y && endYear > y){
                    var startDay = 1
                    var endDay = CalendarHelper().daysInMonth(date: selectedDate)
                    if(Int(day)! >= startDay && Int(day)! <= endDay){
                        daySchedule.append(i)
                    }
                }
                else if(startYear == y){
                    if(startMonth == m){
                        var startDay = CalendarHelper().daysOfMonth(date: CalendarHelper().StringtoDate(string: i.startDate))
                        var endDay = CalendarHelper().daysInMonth(date: CalendarHelper().StringtoDate(string: i.startDate))
                        if(Int(day)! >= startDay && Int(day)! <= endDay){
                            daySchedule.append(i)
                        }
                    }
                    else if(startMonth <= m){
                        var startDay = 1
                        var endDay = CalendarHelper().daysInMonth(date: selectedDate)
                        if(Int(day)! >= startDay && Int(day)! <= endDay){
                            daySchedule.append(i)
                        }
                    }
                }
                else if(endYear == y){
                    if(endMonth == m){
                        var startDay = 1
                        var endDay = CalendarHelper().daysOfMonth(date: CalendarHelper().StringtoDate(string: i.endDate))
                        if(Int(day)! >= startDay && Int(day)! <= endDay){
                            daySchedule.append(i)
                        }
                    }
                    else if(endMonth > m){
                        var startDay = 1
                        var endDay = CalendarHelper().daysInMonth(date: selectedDate)
                        if(Int(day)! >= startDay && Int(day)! <= endDay){
                            daySchedule.append(i)
                        }
                    }
                }
            }
        }
        return daySchedule
    }
    
    func AddScheduleList(){
        for i in self.userinfo.schedules{
            var newschedule:Schedule = Schedule(title: i[0], startDate: i[1], endDate: i[2], startTime: i[3], endTime: i[4])
            
            scheduleList.append(newschedule)
        }
    }
    
    func MinusMonth(m: Int) -> Int{
        var m = m
        m -= 1
        if(m == 0){
            m = 12
        }
        return m
    }
    
    func PlusMonth(m: Int) -> Int{
        var m = m
        m += 1
        if(m == 13){
            m = 1
        }
        return m
    }
    
    
}
