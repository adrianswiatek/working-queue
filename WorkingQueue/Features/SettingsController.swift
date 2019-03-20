import UIKit

public class SettingsController: UITableViewController, ColorThemeRefreshable {

    private var sections: SettingsSections!
    private let cellHeight: CGFloat = 44

    public override func viewDidLoad() {
        super.viewDidLoad()

        sections = SettingsSections { [weak self] section in
            guard let `self` = self else { return }

            let indexPaths =
                stride(from: section.numberOfCells - 1, through: 0, by: -1).map { IndexPath(row: $0, section: 0) }

            if section.isExpanded {
                self.tableView.insertRows(at: indexPaths, with: .top)
            } else {
                self.tableView.deleteRows(at: indexPaths, with: .top)
            }
        }

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
        return sections.count
    }

    public override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sections[section]?.header
    }

    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section]?.numberOfVisibleCells ?? 0
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = sections[indexPath.section]?.cells[indexPath.row] else {
            fatalError("Cell has not been found.")
        }

        return cell
    }

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
