//
//  CalendarHelper.swift
//  meus
//
//  Created by 박중선 on 2022/06/06.
//

import Foundation
import UIKit

class CalendarHelper{
    let calendar = Calendar.current
    
    func plusMonth(date: Date) -> Date{
        return calendar.date(byAdding: .month, value: 1, to: date)! // 달에 값을 1추가
    }
    
    func minusMonth(date: Date) -> Date{
        return calendar.date(byAdding: .month, value: -1, to: date)! // 달에 값을 -1추가
    }
    
    func monthString(date: Date) -> String{ // 2022년 6월 7일 => 6월
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_kr") // 한국시간 표시
        formatter.dateFormat = "MMMM"
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
}
