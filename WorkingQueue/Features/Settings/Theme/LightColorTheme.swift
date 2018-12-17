import UIKit

class LightColorTheme: ColorTheme {
    var type: ColorThemeType = .dark

    var textColor: UIColor = .init(white: 0, alpha: 0.7)
    var tintColor: UIColor = .init(white: 0, alpha: 0.9)
    var accentColor: UIColor = .init(white: 0.95, alpha: 1)
    var backgroundColor: UIColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
    var separatorColor: UIColor = .init(white: 0.75, alpha: 1)

    var barStyle: UIBarStyle = .default
}
