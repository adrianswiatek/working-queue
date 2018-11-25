final class WorkingQueue<T> {
    var delegate: QueueWithSectionsDelegate?

    var numberOfSections: Int {
        return items.count
    }

    private var options: QueueWithSectionsOptions
    private var items: [[T]]

    init(options: QueueWithSectionsOptions) {
        self.options = options
        self.items = []
    }

    func enqueue(item: T) {
        if newSectionHasToBeAdded() {
            items.append([T]())
            delegate?.didAddSection(numberOfSections - 1)
        }

        let section = numberOfSections - 1
        items[section].append(item)
        delegate?.didEnqueueAt(section: section, row: numberOfRowsIn(section: section) - 1)
    }

    private func newSectionHasToBeAdded() -> Bool {
        if numberOfSections == 0 {
            return true
        }

        let lastSection = numberOfSections - 1
        return numberOfRowsIn(section: lastSection) == options.getMaximumNumberOfRowsFor(section: lastSection)
    }

    func dequeue() {
        if numberOfRowsIn(section: 0) > 0 {
            items[0].remove(at: 0)
            delegate?.didDequeueAt(section: 0, row: 0)

            moveItemsBetweenSectionsAfterDelete()
            cleanSectionsAfterDelete()
        }
    }

    func numberOfRowsIn(section: Int) -> Int {
        return numberOfSections > section ? items[section].count : 0
    }

    func get(section: Int, row: Int) -> T? {
        return numberOfRowsIn(section: section) >= row ? items[section][row] : nil
    }

    func remove(section: Int, row: Int) {
        guard numberOfRowsIn(section: section) > row else { return }

        items[section].remove(at: row)
        delegate?.didRemoveAt(section: section, row: row)

        moveItemsBetweenSectionsAfterDelete()
        cleanSectionsAfterDelete()
    }

    private func moveItemsBetweenSectionsAfterDelete() {
        for index in 0 ..< options.maximumNumberOfSections - 1 {
            if numberOfSections > index + 1,
                numberOfRowsIn(section: index) < options.getMaximumNumberOfRowsFor(section: index),
                numberOfRowsIn(section: index + 1) > 0 {

                items[index].append(items[index + 1].remove(at: 0))

                let appendedItemRow = numberOfRowsIn(section: index) - 1
                delegate?.didMove(at: (section: index + 1, row: 0), to: (section: index, row: appendedItemRow))
            }
        }
    }

    private func cleanSectionsAfterDelete() {
        for index in stride(from: options.maximumNumberOfSections - 1, through: 0, by: -1) {
            if numberOfSections <= index || items[index].count > 0 {
                continue
            }

            items.remove(at: index)
            delegate?.didRemoveSection(index)
        }
    }
}
