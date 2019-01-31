class WorkflowEntry {
    public var name: String
    public var currentItem: QueueEntry?

    public var currentItemName: String {
        return currentItem?.name ?? "[nothing to do]"
    }

    public var numberOfItems: Int {
        return queue.count
    }

    public var queue: [QueueEntry]

    public init(name: String, queue: [QueueEntry], currentItem: QueueEntry?) {
        self.name = name
        self.queue = queue
        self.currentItem = currentItem
    }

    public convenience init(name: String) {
        self.init(name: name, queue: [], currentItem: nil)
    }

    public func addQueueEntry(_ queueEntry: QueueEntry) {
        queue.append(queueEntry)
    }

    public func getQueueEntires() -> [QueueEntry] {
        return queue
    }

    public func setQueueEntries(_ queueEntries: [QueueEntry]) {
        queue = queueEntries
    }

    public func dequeueEntry() -> QueueEntry? {
        return queue.count > 0 ? queue.remove(at: 0) : nil
    }
}
