import UIKit

extension UINavigationController {
    public func refreshNavigationBar() {
        let navigationBarSuperview = navigationBar.superview
        navigationBar.removeFromSuperview()
        navigationBarSuperview?.addSubview(navigationBar)
    }
}
