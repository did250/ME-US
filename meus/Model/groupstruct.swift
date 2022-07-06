import Foundation

struct groupstruct: Codable{
    var members: [String]
    
    enum Codingkeys: String {
        case members = "members"
    }
}
