import UIKit

protocol ColorTheme {
    var type: ColorThemeType { get }

    var textColor: UIColor { get }
    var tintColor: UIColor { get }
    var accentColor: UIColor { get }
    var backgroundColor: UIColor { get }
    var separatorColor: UIColor { get }

    var barStyle: UIBarStyle { get }
}
