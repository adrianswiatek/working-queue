import UIKit

extension UITableView {
    func refreshCellsColors() {
        visibleCells.compactMap { $0 as? ColorThemeRefreshable }.forEach { $0.refreshColorTheme() }
    }
}
