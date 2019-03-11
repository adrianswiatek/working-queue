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
        guard current.type != themeType else { return }

        current = themeFactory.create(themeType)

        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.refreshColorTheme()
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
