public protocol SettingsSection: ColorThemeRefreshable {
    var header: SettingsHeader { get }
    var cells: [SettingsCell] { get }
    var totalNumberOfCells: Int { get }
    var numberOfVisibleCells: Int { get }
    var isExpanded: Bool { get set }

    init(
        _ factory: SettingsFactory,
        _ headerDidTap: @escaping (SettingsSection) -> Void,
        _ cellDidTap: @escaping (SettingsSection, SettingsCell) -> Void)
}
