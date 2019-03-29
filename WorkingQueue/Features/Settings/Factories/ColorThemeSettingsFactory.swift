public class ColorThemeSettingsFactory: SettingsFactory {

    private let colorThemeTypes: [ColorThemeType]

    init() {
        let currentColorThemeType = Theme.shared.current.type
        var colorThemeTypes = ColorThemeType.allCases.filter { $0 != currentColorThemeType }
        colorThemeTypes.append(currentColorThemeType)

        self.colorThemeTypes = colorThemeTypes
    }

    public func getHeader() -> SettingsHeader {
        return SettingsHeader()
    }

    public func getHeaderViewModel() -> SettingsHeaderViewModel {
        let value = Theme.shared.current.type.rawValue
        return SettingsHeaderViewModel(name: "Color theme", value: value, isExpanded: false)
    }

    public func getCells() -> [SettingsCell] {
        return colorThemeTypes.map { _ in SettingsCell() }
    }

    public func getCellsViewModels() -> [String] {
        return colorThemeTypes.map { $0.rawValue }
    }
}
