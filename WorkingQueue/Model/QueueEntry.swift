class QueueEntry {
    var name: String

    init(name: String) {
        self.name = name
    }
}

extension QueueEntry: Equatable {
    static func == (lhs: QueueEntry, rhs: QueueEntry) -> Bool {
        return lhs.name == rhs.name
    }
}
