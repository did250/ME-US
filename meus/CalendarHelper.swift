import Foundation
import UIKit

class CalendarHelper{
    let calendar = Calendar.current
    
    func dateToString(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    func dateToStringOnlyDay(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    func dateToStringNoYear(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 dd일"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    func timeToString(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "a hh시 mm분"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    func StringtoDate(string: String) -> Date{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter.date(from: string)!
    }
    
    func plusMonth(date: Date) -> Date{
        return calendar.date(byAdding: .month, value: 1, to: date)! // 달에 값을 1추가
    }
    
    func minusMonth(date: Date) -> Date{
        return calendar.date(byAdding: .month, value: -1, to: date)! // 달에 값을 -1추가
    }
    
    func monthString(date: Date) -> String{ // 2022년 6월 7일 => 6월
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_kr") // 한국시간 표시
        formatter.dateFormat = "M"
        return formatter.string(from: date)
    }
    
    func yearString(date: Date) -> String{ // 2022년 6월 7일 => 2022
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_kr") // 한국시간 표시
        formatter.dateFormat = "yyyy"
        return formatter.string(from: date)
    }
    
    func daysInMonth(date: Date) -> Int{ // 각 달의 날짜가 몇일까지인지 반환
        let range = calendar.range(of: .day, in: .month, for: date)
        return range!.count
    }
    
    func daysOfMonth(date: Date) -> Int{ // 선택된 날의 일을 반환
        let components = calendar.dateComponents([.day], from: date)
        return components.day!
    }
    
    func firstOfMonth(date: Date) -> Date{ // 달의 첫째날로 반환
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components)!
    }
    
    func weekDay(date: Date) -> Int{ // 날짜의 요일별 정수값 반환 
        let components = calendar.dateComponents([.weekday], from: date)
        return components.weekday! - 1
    }
    
    func addDays(date: Date, days: Int) -> Date{
        return calendar.date(byAdding: .day, value: 1, to: date)!
    }
    
    func sundayForDate(date: Date) -> Date{
        var current = date
        let oneWeekAgo = addDays(date: current, days: -7)
        
        while(current > oneWeekAgo){
            let currentWeekDay = calendar.dateComponents([.weekday], from: current).weekday
            if(currentWeekDay == 1){
                return current
            }
            current = addDays(date: current, days: 1)
        }
        return current
    }
}
