public class ColorThemeSettingsFactory: SettingsFactory {
    public func getHeader() -> SettingsHeader {
        let header = SettingsHeader()
        header.viewModel = SettingsHeaderViewModel(name: "Color theme", value: "Light")
        return header
    }

    public func getCells() -> [SettingsCell] {
        let cell1 = SettingsCell()
        cell1.viewModel = "Dark"

        let cell2 = SettingsCell()
        cell2.viewModel = "Colorful"

        let cell3 = SettingsCell()
        cell3.viewModel = "Ultraviolet"

        return [cell1, cell2, cell3]
    }
}
