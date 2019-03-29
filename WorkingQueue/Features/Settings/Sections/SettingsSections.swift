public class SettingsSections: ColorThemeRefreshable {

    public var count: Int {
        return sections.count
    }

    private let headerDidTap: (SettingsSection) -> Void
    private let cellDidTap: (SettingsSection, SettingsCell) -> Void
    private var sections: [SettingsSection] = []

    init(
        headerDidTap: @escaping (SettingsSection) -> Void,
        cellDidTap: @escaping (SettingsSection, SettingsCell) -> Void) {

        self.headerDidTap = headerDidTap
        self.cellDidTap = cellDidTap
        self.registerSections()
    }

    public subscript(index: Int) -> SettingsSection? {
        guard index < count else { return nil }

        return sections[index]
    }

    public func getIndex(of section: SettingsSection) -> Int? {
        return sections.firstIndex { $0 === section }
    }

    private func registerSections() {
        sections.append(getColorThemeSettingsSection())
    }

    private func getColorThemeSettingsSection() -> SettingsSection {
        let factory = ColorThemeSettingsFactory()
        return ColorThemeSettingsSection(factory, headerDidTap, cellDidTap)
    }

    public func refreshColorTheme() {
        sections.forEach { $0.refreshColorTheme() }
    }
}
