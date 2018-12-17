import UIKit

extension UIColor {
    static var textColor: UIColor {
        return Theme.shared.current.textColor
    }

    static var tintColor: UIColor {
        return Theme.shared.current.tintColor
    }

    static var accentColor: UIColor {
        return Theme.shared.current.accentColor
    }

    static var backgroundColor: UIColor {
        return Theme.shared.current.backgroundColor
    }

    static var separatorColor: UIColor {
        return Theme.shared.current.separatorColor
    }
}
