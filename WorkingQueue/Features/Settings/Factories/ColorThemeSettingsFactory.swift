public class ColorThemeSettingsFactory: SettingsFactory {

    private let colorThemeTypes: [ColorThemeType]

    init() {
        colorThemeTypes = ColorThemeType.allCases
    }

    public func getHeader() -> SettingsHeader {
        return SettingsHeader()
    }

    public func getHeaderViewModel() -> SettingsHeaderViewModel {
        return SettingsHeaderViewModel(name: "Color theme", value: "Light", isExpanded: false)
    }

    public func getCells() -> [SettingsCell] {
        return colorThemeTypes.map { _ in SettingsCell() }
    }

    public func getCellsViewModels() -> [String] {
        return colorThemeTypes.map { $0.rawValue }
    }
}
