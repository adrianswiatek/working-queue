public protocol SettingsFactory {
    func getHeader() -> SettingsHeader
    func getCells() -> [SettingsCell]
}
