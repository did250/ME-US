import Foundation

struct userstruct: Codable{
    var Frequest: [String]
    var Grequest: [String]
    var friends: [String]
    var groups: [String]
    var id: String
    var key: String
    var name: String
    var schedules: [[String]]
    var uid: String
    enum Codingkeys: String {
        case Frequest = "Frequest"
        case Grequest = "Grequest"
        case friends = "friends"
        case groups = "groups"
        case id = "id"
        case key = "key"
        case name = "name"
        case schedules = "scheduels"
        case uid = "uid"
    }
}
