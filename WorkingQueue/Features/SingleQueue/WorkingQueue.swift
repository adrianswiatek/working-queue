enum WorkingQueueSection: Int, CaseIterable {
    case next, forLater
}

protocol WorkingQueueDelegate {
    func didEnqueueAt(section: WorkingQueueSection, row: Int)
    func didDequeueAt(section: WorkingQueueSection, row: Int)
    func didRemoveAt(section: WorkingQueueSection, row: Int)
    func didMove(at: (section: WorkingQueueSection, row: Int), to: (section: WorkingQueueSection, row: Int))
    func didAddSection(_ section: WorkingQueueSection)
    func didRemoveSection(_ section: WorkingQueueSection)
}

class WorkingQueue<T> {
    var delegate: WorkingQueueDelegate?

    var numberOfSections: Int {
        return items.count
    }

    private var items: [[T]]

    init() {
        items = []
    }

    func enqueue(item: T) {
        if numberOfSections == 0 {
            items.append([T]())
            delegate?.didAddSection(.next)

            items[WorkingQueueSection.next.rawValue].append(item)
            delegate?.didEnqueueAt(section: .next, row: 0)
        } else if numberOfSections == 1 {
            items.append([T]())
            delegate?.didAddSection(.forLater)

            items[WorkingQueueSection.forLater.rawValue].append(item)
            delegate?.didEnqueueAt(section: .forLater, row: 0)
        } else {
            items[WorkingQueueSection.forLater.rawValue].append(item)
            delegate?.didEnqueueAt(section: .forLater, row: numberOfRowsIn(section: .forLater) - 1)
        }
    }

    func dequeue() {
        if numberOfRowsIn(section: .next) > 0 {
            items[0].remove(at: 0)
            delegate?.didDequeueAt(section: .next, row: 0)

            moveSectionsAfterDelete()
            cleanSectionsAfterDelete()
        }
    }

    func numberOfRowsIn(section: WorkingQueueSection) -> Int {
        return numberOfSections > section.rawValue ? items[section.rawValue].count : 0
    }

    func numberOfRowsIn(section: Int) -> Int {
        if let section = WorkingQueueSection(rawValue: section) {
            return numberOfRowsIn(section: section)
        } else {
            return 0
        }
    }

    func get(section: WorkingQueueSection, row: Int) -> T? {
        return numberOfRowsIn(section: section) >= row ? items[section.rawValue][row] : nil
    }

    func get(section: Int, row: Int) -> T? {
        if let section = WorkingQueueSection(rawValue: section) {
            return items[section.rawValue][row]
        } else {
            return nil
        }
    }

    func remove(section: WorkingQueueSection, row: Int) {
        guard numberOfRowsIn(section: section) > row else { return }

        items[section.rawValue].remove(at: row)
        delegate?.didRemoveAt(section: section, row: row)

        moveSectionsAfterDelete()
        cleanSectionsAfterDelete()
    }

    func remove(section: Int, row: Int) {
        if let section = WorkingQueueSection(rawValue: section) {
            remove(section: section, row: row)
        }
    }

    private func moveSectionsAfterDelete() {
        for index in 0 ..< WorkingQueueSection.allCases.count - 1 {
            if numberOfSections > index + 1,
                numberOfRowsIn(section: index) == 0,
                numberOfRowsIn(section: index + 1) > 0 {

                items[index].append(items[index + 1].remove(at: 0))

                let currentSection = WorkingQueueSection(rawValue: index)!
                let nextSection = WorkingQueueSection(rawValue: index + 1)!

                delegate?.didMove(at: (section: nextSection, row: 0), to: (section: currentSection, row: 0))
            }
        }
    }

    private func cleanSectionsAfterDelete() {
        for index in stride(from: WorkingQueueSection.allCases.count - 1, through: 0, by: -1) {
            if numberOfSections <= index || items[index].count > 0 {
                continue
            }

            items.remove(at: index)
            delegate?.didRemoveSection(WorkingQueueSection(rawValue: index)!)
        }
    }
}
