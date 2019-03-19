public protocol SettingsSection {
    var header: SettingsHeader { get }
    var isExpanded: Bool { get set }

    init(_ factory: SettingsFactory, _ headerDidTap: @escaping (SettingsSection) -> Void)
}
