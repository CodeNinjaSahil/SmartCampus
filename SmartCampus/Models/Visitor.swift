import UIKit

enum VisitorStatus: String {
    case active = "ACTIVE"
    case exited = "EXITED"
    case expired = "EXPIRED"

    var color: UIColor {
        switch self {
        case .active: return .systemGreen
        case .exited: return .systemGray
        case .expired: return .systemOrange
        }
    }
}

struct Visitor {
    let id = UUID()
    var name: String
    var phone: String
    var host: String
    var department: String
    var purpose: String
    var visitDate: Date
    let passID: String
    var status: VisitorStatus
}
