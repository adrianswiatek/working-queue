import UIKit

public class Theme {
    public static private(set) var shared = Theme()

    private(set) var current: ColorTheme
    private let themeFactory: ThemeFactory

    private init() {
        current = LightColorTheme()
        themeFactory = ThemeFactory()
    }

    public func switchTheme(to themeType: ColorThemeType) {
        if current.type != themeType {
            current = themeFactory.create(themeType)
        }
    }

    private class ThemeFactory {
        func create(_ themeType: ColorThemeType) -> ColorTheme {
            switch themeType {
            case .dark:
                return DarkColorTheme()
            case .light:
                return LightColorTheme()
            }
        }
    }
}
