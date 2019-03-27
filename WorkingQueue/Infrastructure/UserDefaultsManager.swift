import Foundation

public struct UserDefaultsManager {

    private let colorThemeTypeKey = "ColorThemeType"
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    public func setColorThemeType(to colorThemeType: ColorThemeType) {
        userDefaults.set(colorThemeType.rawValue, forKey: colorThemeTypeKey)
    }

    public func getColorThemeType() -> ColorThemeType? {
        guard let theme = userDefaults.string(forKey: colorThemeTypeKey) else {
            return nil
        }

        return ColorThemeType(rawValue: theme)
    }
}
