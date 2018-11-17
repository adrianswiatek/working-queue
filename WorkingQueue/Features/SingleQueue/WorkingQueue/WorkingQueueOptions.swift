struct WorkingQueueOptions {
    let maximumNumberOfSections: Int
    private var maximumNumberOfRowsForSection: [Int: Int]

    init(maximumNumberOfSections: Int) {
        self.maximumNumberOfSections = maximumNumberOfSections > 0 ? maximumNumberOfSections : 1

        self.maximumNumberOfRowsForSection = [Int: Int]()
        let unlimitedNumberOfRows = -1
        for sectionNumber in 0 ..< maximumNumberOfSections {
            self.maximumNumberOfRowsForSection[sectionNumber] = unlimitedNumberOfRows
        }
    }

    func getMaximumNumberOfRowsFor(section: Int) -> Int {
        return maximumNumberOfRowsForSection[section] ?? 0
    }

    mutating func setMaximumNumberOfRowsFor(section: Int, to maximumNumberOfRows: Int) {
        guard maximumNumberOfRows > 0 else {
            return
        }

        maximumNumberOfRowsForSection[section] = maximumNumberOfRows
    }
}
