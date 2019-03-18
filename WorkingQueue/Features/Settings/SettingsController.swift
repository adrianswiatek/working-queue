import UIKit

public class SettingsController: UITableViewController, ColorThemeRefreshable {

    public override func viewDidLoad() {
        super.viewDidLoad()

        setViews()
        refreshColorTheme()
    }

    private func setViews() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Settings"

        tableView.tableFooterView = UIView()
    }

    public func refreshColorTheme() {
        navigationController?.refreshNavigationBar()
        navigationController?.view.backgroundColor = .accentColor
        tableView.backgroundColor = .accentColor
        tableView.refreshCellsColors()
    }
}
