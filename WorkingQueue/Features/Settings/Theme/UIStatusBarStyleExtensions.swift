import UIKit

extension UIStatusBarStyle {
    static var currentStyle: UIStatusBarStyle {
        return Theme.shared.current.statusBarStyle
    }
}
