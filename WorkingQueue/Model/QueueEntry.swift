public class QueueEntry {
    var name: String

    public init(name: String) {
        self.name = name
    }
}

extension QueueEntry: Equatable {
    public static func == (lhs: QueueEntry, rhs: QueueEntry) -> Bool {
        return lhs.name == rhs.name
    }
}
