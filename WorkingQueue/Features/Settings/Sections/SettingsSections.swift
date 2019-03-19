public class SettingsSections {

    public var count: Int {
        return sections.count
    }

    private let headerDidTap: (SettingsSection) -> Void
    private var sections: [SettingsSection] = []

    init(headerDidTap: @escaping (SettingsSection) -> Void) {
        self.headerDidTap = headerDidTap
        self.registerSections()
    }

    public subscript(index: Int) -> SettingsSection? {
        guard index < count else { return nil }

        return sections[index]
    }

    private func registerSections() {
        sections.append(getColorThemeSettingsSection())
    }

    private func getColorThemeSettingsSection() -> SettingsSection {
        let factory = ColorThemeSettingsFactory()
        return ColorThemeSettingsSection(factory, headerDidTap)
    }
}
