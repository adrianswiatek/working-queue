import UIKit

extension UIBarStyle {
    static var currentStyle: UIBarStyle {
        return Theme.shared.current.barStyle
    }
}
