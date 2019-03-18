import UIKit

public class SettingsController: UITableViewController, ColorThemeRefreshable {

    private let cellHeight: CGFloat = 44

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

    public override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellHeight
    }

    public override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = SettingsHeader()
        header.viewModel = SettingsHeaderViewModel(name: "Color theme", value: "Light")
        return header
    }
}
