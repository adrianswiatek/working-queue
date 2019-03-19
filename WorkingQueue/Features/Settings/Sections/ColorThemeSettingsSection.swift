public class ColorThemeSettingsSection: SettingsSection {
    public let header: SettingsHeader
    public var isExpanded: Bool

    public required init(_ factory: SettingsFactory, _ headerDidTap: @escaping (SettingsSection) -> Void) {
        self.isExpanded = false
        self.header = factory.getHeader()

        self.header.headerDidTap = { [weak self] in
            guard let `self` = self else { return }
            self.isExpanded.toggle()
            headerDidTap(self)
        }
    }
}
