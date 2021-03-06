import Foundation
import Combine
import Firebase
import FirebaseDatabase
import CodableFirebase

class ViewModel: ObservableObject {
    
    var ref : DatabaseReference = Database.database().reference()
    
    @Published var userinfo : userstruct = userstruct(Frequest: [""], Grequest: [""], friends: [""], groups: ["1"], id: "1", key: "", name: "0", schedules: [[""]], uid: "")
    
    @Published var groupinfo : groupstruct = groupstruct(members: [""])
    
    init(){
        print("VM init")
    }
}

extension ViewModel {
    func adduser(uid:String, id: String, name: String){
        self.ref.child("users").child(uid).setValue([ "key": ref.childByAutoId().key, "id": id , "uid": uid,"name": name, "friends": ["friends"], "groups": ["groups"], "Frequest": ["Frequest"], "Grequest": ["Grequest"], "schedules": [["크리스마스","2022년 12월 25일","2022년 12월 25일","오전 11시 11분", "오전 11시 12분"]] ])
    }
    
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
    
    func LoadGroup(group: String, completion: @escaping (groupstruct) -> ()){
        ref.child("Group").child(group).getData{
            (error, snapshot) in
            if let error = error {
                print("Error2 \(error)")
            }
            else {
                let value = snapshot?.value
                if let data = try? FirebaseDecoder().decode(groupstruct.self, from: value){
                    self.groupinfo = data
                    completion(data)
                }
                else {
                    print("Error2")
                }
            }
        }
    }
    
    func AddGroup(new: String, completion: @escaping (Int)->()){
        self.userinfo.groups.append(new)
        self.ref.child("users").child(self.userinfo.uid).updateChildValues(["groups": self.userinfo.groups])
        self.ref.child("Group").child(new).setValue(["members": [self.userinfo.name]])
        completion(1)
    }
    
    func MixedSchedule(members : [String], completion: @escaping ([Schedule]) -> ()) -> (){
        
        for i in members{
            
            var member : String = ""
            self.ref.child("users").queryOrdered(byChild: "name").queryEqual(toValue: i).observeSingleEvent(of: .value, with: {
                snapshot in
                for child in snapshot.children{
                    let snap = child as! DataSnapshot
                    member = snap.key
                    //print("###")
                    //print(member)
                    self.ref.child("users").child(member).child("schedules").getData{
                        (error,snapshot) in
                        if let error = error {
                            print("Error \(error)")
                        }
                        else{
                            guard let value = snapshot?.value else {return}
                            if let data = try? FirebaseDecoder().decode([[String]].self, from: value){
                                print("1111111")
                                var newschedule : [[String]] = data
                                for j in newschedule{
                                    var newschedule:Schedule = Schedule(title: j[0], startDate: j[1], endDate: j[2], startTime: j[3], endTime: j[4])
                                    //print(j)
                                    scheduleList2.append(newschedule)
                                }
                                
                                completion(scheduleList2)
                                
//                                for i in scheduleList2{
//                                    print(i.title)
//                                }
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

    func sendFrequest(friendid : String, flag : String, groupname:String, completion: @escaping (Int) -> ()) {
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
                            if let data2 = try? FirebaseDecoder().decode([String].self, from: value){
                                var array: [String] = data2
                                array.append(groupname)
                                self.ref.child("users").child(frienduid).updateChildValues(["Grequest": array])
                                completion(1)
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
        self.userinfo.groups.append(target)
        self.ref.child("users").child(self.userinfo.uid).updateChildValues(["groups": self.userinfo.groups])
        self.ref.child("Group").child(target).child("members").getData {
            (error,snapshot) in
            if let error = error {
                print("Error \(error)")
            }
            else{
                guard let value = snapshot?.value else {return}
                if let data2 = try? FirebaseDecoder().decode([String].self, from: value){
                    var array: [String] = data2
                    array.append(self.userinfo.name)
                    self.ref.child("Group").child(target).updateChildValues(["members":array])
                    var temp = self.userinfo.Grequest
                    var s = -1
                    for i in temp{
                        s = s+1
                        if i == target{
                            temp.remove(at: s)
                        }
                    }
                    self.ref.child("users").child(self.userinfo.uid).updateChildValues(["Grequest":temp])
                    self.userinfo.Grequest = temp
                }
                else{
                    print("Error")
                }
            }
        }
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
    
    func DeleteSchedule(target: String){
        print("delete")
        var t : Int = -1
        for i in scheduleList{
            t = t+1
            if i.title == target{
                scheduleList.remove(at: t)
            }
        }
        for i in self.userinfo.schedules.startIndex...self.userinfo.schedules.endIndex-1{
            if(self.userinfo.schedules[i][0] == target){
                self.userinfo.schedules.remove(at: i)
                break
            }
        }
        self.ref.child("users").child(self.userinfo.uid).updateChildValues(["schedules":self.userinfo.schedules])
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
    
    func AddGroupMembers() -> [String]{
        var members : [String] = []
        for i in self.groupinfo.members{
            members.append(i)
        }
        return members
    }
    
    
}
