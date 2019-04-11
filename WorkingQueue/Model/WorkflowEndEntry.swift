public class WorkflowEndEntry {

    private var entries: [QueueEntry]

    public var numberOfEntries: Int {
        return entries.count
    }

    public init() {
        self.entries = []
    }

    public func addEntry(_ entry: QueueEntry) {
        entries.append(entry)
    }

    public func removeEntry(_ entry: QueueEntry) {
        entries.removeAll(where: { $0 == entry })
    }

    public func getEntries() -> [QueueEntry] {
        return entries
    }

    public func removeAllEntries() {
        entries.removeAll()
    }
}
