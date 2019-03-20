public protocol SettingsSection {
    var header: SettingsHeader { get }
    var cells: [SettingsCell] { get }
    var numberOfCells: Int { get }
    var numberOfVisibleCells: Int { get }
    var isExpanded: Bool { get set }

    init(_ factory: SettingsFactory, _ headerDidTap: @escaping (SettingsSection) -> Void)
}
