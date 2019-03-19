public class ColorThemeSettingsFactory: SettingsFactory {
    public func getHeader() -> SettingsHeader {
        let header = SettingsHeader()
        header.viewModel = SettingsHeaderViewModel(name: "Color theme", value: "Light")
        return header
    }
}
