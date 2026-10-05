import Foundation

/// In-memory storage (Phase 18). Swap for Core Data later if required.
final class VisitorStore {
    static let shared = VisitorStore()

    private(set) var visitors: [Visitor] = []
    /// The pass shown in the Pass tab.
    var currentPassID: String?
    private var counter = 0

    private init() {
        let samples: [(String, String, String, String, String, VisitorStatus)] = [
            ("Ayansh Pal", "9876543210", "Dr. Sharma", "CSE", "Meeting", .active),
            ("Rahul Kumar", "9123456780", "Prof. Verma", "Admin", "Official Work", .exited),
            ("Sahil", "9988776655", "Dr. Mehta", "ECE", "Interview", .active)
        ]
        for s in samples {
            register(name: s.0, phone: s.1, host: s.2, department: s.3,
                     purpose: s.4, visitDate: Date(), status: s.5)
        }
        currentPassID = nil
    }

    @discardableResult
    func register(name: String, phone: String, host: String, department: String,
                  purpose: String, visitDate: Date, status: VisitorStatus = .active) -> Visitor {
        counter += 1
        let passID = String(format: "VIS-%03d", counter)
        let visitor = Visitor(name: name, phone: phone, host: host, department: department,
                              purpose: purpose, visitDate: visitDate, passID: passID, status: status)
        visitors.append(visitor)
        currentPassID = passID
        return visitor
    }

    func visitor(withPassID passID: String) -> Visitor? {
        visitors.first { $0.passID == passID }
    }

    func updateStatus(passID: String, to status: VisitorStatus) {
        guard let i = visitors.firstIndex(where: { $0.passID == passID }) else { return }
        visitors[i].status = status
    }

    var todayCount: Int {
        visitors.filter { Calendar.current.isDateInToday($0.visitDate) }.count
    }

    var activeCount: Int {
        visitors.filter { $0.status == .active }.count
    }
}
