import UIKit

class SettingsController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setViews()
    }

    private func setViews() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Settings"
        view.backgroundColor = .backgroundColor
        tableView.separatorStyle = .none
    }
}
