import UIKit

extension UICollectionViewCell {
    func refreshSubviewsColors() {
        subviews.compactMap { $0 as? ColorThemeRefreshable }.forEach { $0.refreshColorTheme() }
    }
}
