public class ColorThemeSettingsSection: SettingsSection {
    public let header: SettingsHeader
    public var isExpanded: Bool

    public var numberOfVisibleCells: Int {
        return cells.count
    }

    public var cells: [SettingsCell] {
        return isExpanded ? allCells : []
    }

    public var numberOfCells: Int {
        return allCells.count
    }

    private var allCells: [SettingsCell]

    public required init(_ factory: SettingsFactory, _ headerDidTap: @escaping (SettingsSection) -> Void) {
        self.isExpanded = false
        self.header = factory.getHeader()
        self.allCells = factory.getCells()

        self.header.headerDidTap = { [weak self] in
            guard let `self` = self else { return }
            self.isExpanded.toggle()
            headerDidTap(self)
        }
    }
}
