
import Foundation

var scheduleList = [Schedule]()
var scheduleList2 = [Schedule]() 

class Schedule{
    //var id: Int!
    var title: String
    var startDate: String
    var endDate: String
    var startTime: String
    var endTime: String
    
    init(title: String, startDate: String, endDate:String, startTime: String, endTime: String){
        self.title = title
        self.startTime = startTime
        self.endTime = endTime
        self.startDate = startDate
        self.endDate = endDate
    }

    func scheduleForDate(date: Date) -> [Schedule]{
        var daysSchedule = [Schedule]()
        for schedule in scheduleList{

            if(Calendar.current.isDate(CalendarHelper().StringtoDate(string: schedule.startDate), inSameDayAs: date)){
                
                daysSchedule.append(schedule)
            }
        }
        return daysSchedule
    }
    
}
