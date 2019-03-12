import UIKit

extension UICollectionView {
    func refreshCellsColors() {
        visibleCells.compactMap { $0 as? ColorThemeRefreshable }.forEach { $0.refreshColorTheme() }
    }
}
