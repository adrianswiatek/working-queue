public class ColorThemeSettingsSection: SettingsSection {
    public let header: SettingsHeader
    private let headerViewModel: SettingsHeaderViewModel

    public var isExpanded: Bool

    public var numberOfVisibleCells: Int {
        return max(cells.count - 1, 0)
    }

    public var cells: [SettingsCell] {
        return isExpanded ? allCells.filter { $0.viewModel != headerViewModel.value } : []
    }

    public var numberOfCells: Int {
        return max(allCells.count - 1, 0)
    }

    private var allCells: [SettingsCell]

    public required init(
        _ factory: SettingsFactory,
        _ headerDidTap: @escaping (SettingsSection) -> Void,
        _ cellDidTap: @escaping (SettingsSection, Int) -> Void) {
        self.isExpanded = false

        self.header = factory.getHeader()
        self.headerViewModel = factory.getHeaderViewModel()
        self.header.viewModel = headerViewModel

        self.allCells = factory.getCells()
        let cellsViewModels = factory.getCellsViewModels()

        self.header.headerDidTap = { [weak self] in
            guard let `self` = self else { return }
            self.isExpanded.toggle()
            headerDidTap(self)
        }

        (0 ..< numberOfCells).forEach { [weak self] cellIndex in
            guard let `self` = self else { return }

            let cell = self.allCells[cellIndex]
            cell.viewModel = cellsViewModels[cellIndex]
            cell.cellDidTap = {
                self.isExpanded = false
                cellDidTap(self, cellIndex)
            }
        }
    }
}
