public class WorkflowEntry {
    public var name: String
    public var currentQueueEntry: QueueEntry?

    public var currenQueueEntryName: String {
        return currentQueueEntry?.name ?? "[nothing to do]"
    }

    public var numberOfEntries: Int {
        return queue.count
    }

    public var queue: [QueueEntry]

    public init(name: String, queue: [QueueEntry], currentItem: QueueEntry?) {
        self.name = name
        self.queue = queue
        self.currentQueueEntry = currentItem
    }

    public convenience init(name: String) {
        self.init(name: name, queue: [], currentItem: nil)
    }

    public func addQueueEntry(_ queueEntry: QueueEntry) {
        queue.append(queueEntry)
    }

    public func removeFirstQueueEntry() -> QueueEntry? {
        return numberOfEntries > 0 ? queue.remove(at: 0) : nil
    }

    public func getQueueEntires() -> [QueueEntry] {
        return queue
    }

    public func setQueueEntries(_ queueEntries: [QueueEntry]) {
        queue = queueEntries
    }

    public func dequeueToCurrent() {
        currentQueueEntry = queue.count > 0 ? queue.remove(at: 0) : nil
    }
}
