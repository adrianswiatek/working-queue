import UIKit

public class SettingsController: UITableViewController, ColorThemeRefreshable {

    private var sections: SettingsSections!
    private let cellHeight: CGFloat = 44

    public override func viewDidLoad() {
        super.viewDidLoad()

        sections = SettingsSections(headerDidTap: headerDidTap, cellDidTap: cellDidTap)

        setViews()
        refreshColorTheme()
    }

    private func headerDidTap(section: SettingsSection) {
        guard let sectionIndex = sections.getIndex(of: section) else {
            fatalError("Section does not exist in the sections list.")
        }

        let indexPaths = (0 ..< section.totalNumberOfCells).map { IndexPath(row: $0, section: sectionIndex)}
        if section.isExpanded {
            tableView.insertRows(at: indexPaths, with: .top)
        } else {
            tableView.deleteRows(at: indexPaths, with: .top)
        }
    }

    private func cellDidTap(section: SettingsSection, cell: SettingsCell) {
        guard let sectionIndex = sections.getIndex(of: section) else {
            fatalError("Section does not exist in the sections list.")
        }

        let indexPaths = (0 ..< section.totalNumberOfCells).map { IndexPath(row: $0, section: sectionIndex)}
        tableView.deleteRows(at: indexPaths, with: .top)

        if let theme = cell.viewModel, let colorThemeType = ColorThemeType(rawValue: theme) {
            (UIApplication.shared.delegate as? AppDelegate)?.switchColorTheme(to: colorThemeType)
        }
    }

    private func setViews() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Settings"

        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
    }

    public func refreshColorTheme() {
        navigationController?.refreshNavigationBar()
        navigationController?.view.backgroundColor = .accentColor
        tableView.backgroundColor = .accentColor
        sections.refreshColorTheme()
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
}
