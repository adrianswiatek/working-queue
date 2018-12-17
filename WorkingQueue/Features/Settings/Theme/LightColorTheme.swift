import UIKit

class LightColorTheme: ColorTheme {
    var type: ColorThemeType = .dark

    var textColor: UIColor = .init(white: 1, alpha: 0.7)
    var tintColor: UIColor = .init(red: 0.94, green: 0.35, blue: 0.19, alpha: 1)
    var accentColor: UIColor = .init(white: 1, alpha: 0.7)
    var backgroundColor: UIColor = .black
    var separatorColor: UIColor = .init(white: 0.15, alpha: 1)
}
