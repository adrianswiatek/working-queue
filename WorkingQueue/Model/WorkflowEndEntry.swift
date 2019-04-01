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

    public func getEntries() -> [QueueEntry] {
        return entries
    }
}
