public protocol SettingsFactory {
    func getHeader() -> SettingsHeader
    func getHeaderViewModel() -> SettingsHeaderViewModel
    func getCells() -> [SettingsCell]
    func getCellsViewModels() -> [String]
}
