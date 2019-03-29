public struct SettingsHeaderViewModel {
    let name: String
    let value: String
    let isExpanded: Bool

    public func getWithModified(isExpanded: Bool) -> SettingsHeaderViewModel {
        return SettingsHeaderViewModel(name: self.name, value: self.value, isExpanded: isExpanded)
    }

    public func getWithModified(value: String) -> SettingsHeaderViewModel {
        return SettingsHeaderViewModel(name: self.name, value: value, isExpanded: self.isExpanded)
    }
}
