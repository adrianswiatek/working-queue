public class ColorThemeSettingsSection: SettingsSection {

    public let header: SettingsHeader
    public var isExpanded: Bool

    public var numberOfVisibleCells: Int {
        return max(cells.count - 1, 0)
    }

    public var cells: [SettingsCell] {
        return isExpanded ? allCells.filter { $0.viewModel != headerViewModel.value } : []
    }

    public var totalNumberOfCells: Int {
        return max(allCells.count - 1, 0)
    }

    private var headerViewModel: SettingsHeaderViewModel {
        didSet {
            header.viewModel = headerViewModel
        }
    }

    private var allCells: [SettingsCell]

    public required init(
        _ factory: SettingsFactory,
        _ headerDidTap: @escaping (SettingsSection) -> Void,
        _ cellDidTap: @escaping (SettingsSection, SettingsCell) -> Void) {
        self.isExpanded = false

        self.header = factory.getHeader()
        self.headerViewModel = factory.getHeaderViewModel()
        self.header.viewModel = self.headerViewModel

        self.allCells = factory.getCells()

        self.header.headerDidTap = { [weak self] in
            guard let `self` = self else { return }
            self.isExpanded.toggle()

            self.headerViewModel = self.headerViewModel.getWithModified(isExpanded: self.isExpanded)

            headerDidTap(self)
        }

        let cellsViewModels = factory.getCellsViewModels()
        for cellIndex in (0 ..< totalNumberOfCells) {
            let cell = allCells[cellIndex]
            cell.viewModel = cellsViewModels[cellIndex]
            cell.cellDidTap = { [weak self] in
                guard let `self` = self else { return }
                guard let colorName = cell.viewModel else { return }

                self.isExpanded = false
                cellDidTap(self, cell)

                cell.viewModel = self.headerViewModel.value

                self.headerViewModel = self.headerViewModel
                    .GetWithModified(value: colorName)
                    .getWithModified(isExpanded: false)
            }
        }
    }

    public func refreshColorTheme() {
        header.refreshColorTheme()
        allCells.forEach { $0.refreshColorTheme() }
    }
}
